//
//  BNDBinding.m
//  BIND
//
//  Created by Marko Hlebar on 27/10/2014.
//  Copyright (c) 2014 Marko Hlebar. All rights reserved.
//

#import "BNDBinding.h"
#import "BNDSpecialKeyPathHandler.h"
#import "BNDBindingTypes.h"
#import "BNDParser.h"
#import <objc/runtime.h>

static NSMutableSet *BNDBindingObject_swizzledClasses = nil;
static NSMutableSet *BNDBindingObject_bindings = nil;

static void *BNDBindingContext = &BNDBindingContext;
NSString * const BNDBindingAssociatedBindingsKey = @"BNDBindingAssociatedBindingsKey";

@interface BNDBindingKVOObserver : NSObject
@property (nonatomic, copy, readonly) NSString *keyPath;
@property (nonatomic, weak, readonly) BNDBinding *binding;

+ (instancetype)observerWithKeyPath:(NSString *)keyPath
                            binding:(BNDBinding *)binding;
- (void)observe:(id)observable;
- (void)unobserve:(id)observable;

@end

@interface BNDBinding ()
@property (nonatomic, weak) id leftObject;
@property (nonatomic, weak) id rightObject;
@property (nonatomic, strong) NSString *leftKeyPath;
@property (nonatomic, strong) NSString *rightKeyPath;
@property (nonatomic) BNDBindingDirection direction;
@property (nonatomic) BNDBindingTransformDirection transformDirection;
@property (nonatomic, strong) NSValueTransformer *valueTransformer;
@property (nonatomic) BOOL shouldSetInitialValues;

@property (nonatomic, strong) BNDBindingKVOObserver *leftObserver;
@property (nonatomic, strong) BNDBindingKVOObserver *rightObserver;
@end

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

@implementation BNDBinding {
    BOOL _locked;
}

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        BNDBindingObject_swizzledClasses = [NSMutableSet new];
        BNDBindingObject_bindings = [NSMutableSet new];
    });
}

- (BOOL)isValidBinding {
    BOOL isValidBinding = [BNDBindingObject_bindings containsObject:self];
    return isValidBinding;
}

- (void)dealloc {
    [self unbind];
}

+ (BNDBinding *)bindingWithBIND:(NSString *)BIND {
    BNDBinding *binding = [BNDBinding new];
    binding.BIND = BIND;
    return binding;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    return [self init];
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.shouldSetInitialValues = YES;
    }
    return self;
}

- (void)setBIND:(NSString *)BIND {
    _BIND = BIND;

    BNDBindingModel *definition = [BNDParser parseBIND:_BIND];
    [self setDefinition:definition];
    
    if (self.leftObject && self.rightObject) {
        [self bind];
    }
}

- (void)setDefinition:(BNDBindingModel *)definition {
    self.leftKeyPath = definition.leftKeyPath;
    self.rightKeyPath = definition.rightKeyPath;
    self.direction = definition.direction;
    self.transformDirection = definition.transformDirection;
    self.valueTransformer = definition.valueTransformer;
    self.shouldSetInitialValues = definition.shouldSetInitialValues;
}

- (void)bindLeft:(id)leftObject
       withRight:(id)rightObject {
    [self unbind];
    
    self.leftObject = leftObject;
    self.rightObject = rightObject;
    
    [self bind];
}

- (void)bind {
    [self setInitialValues];
    [self setupObservers];
    [BNDSpecialKeyPathHandler handleSpecialKeyPathsForBinding:self];
    
    [BNDBindingObject_bindings addObject:self];
}

- (void)unbind {
    if (![self isValidBinding]) {
        return;
    }
    
    [self removeObservers];
    
    self.leftObject = nil;
    self.rightObject = nil;
    
    [BNDBindingObject_bindings removeObject:self];
}

- (void)setInitialValues {
    if (!self.shouldSetInitialValues) {
        return;
    }
    
    if (![self areKeypathsSet]) {
        return;
    }
    
    if (!self.leftObject || !self.rightObject) {
        return;
    }
    
    if (self.direction == BNDBindingDirectionLeftToRight ||
        self.direction == BNDBindingDirectionBoth) {
        id value = [self.leftObject valueForKeyPath:self.leftKeyPath];
        value = [_valueTransformer performSelector:[self transformSelector]
                                        withObject:value];
        [self.rightObject setValue:value forKeyPath:self.rightKeyPath];
    }
    else if (self.direction == BNDBindingDirectionRightToLeft) {
        id value = [self.rightObject valueForKeyPath:self.rightKeyPath];
        value = [_valueTransformer performSelector:[self reverseTransformSelector]
                                        withObject:value];
        
        [self.leftObject setValue:value forKeyPath:self.leftKeyPath];
    }
}

- (SEL)transformSelector {
    return self.transformDirection == BNDBindingTransformDirectionLeftToRight ?
    @selector(transformedValue:) :
    @selector(reverseTransformedValue:);
}

- (SEL)reverseTransformSelector {
    return self.transformDirection == BNDBindingTransformDirectionLeftToRight ?
    @selector(reverseTransformedValue:) :
    @selector(transformedValue:);
}

- (void)setupObservers {
    if (![self areKeypathsSet] || ![self areObjectsSet]) {
        return;
    }
    
    if (self.direction == BNDBindingDirectionLeftToRight ||
        self.direction == BNDBindingDirectionBoth) {
        self.leftObserver = [BNDBindingKVOObserver observerWithKeyPath:self.leftKeyPath
                                                               binding:self];
        [self.leftObserver observe:self.leftObject];
    }
    
    if (self.direction == BNDBindingDirectionRightToLeft ||
        self.direction == BNDBindingDirectionBoth) {
        self.rightObserver = [BNDBindingKVOObserver observerWithKeyPath:self.rightKeyPath
                                                                binding:self];
        [self.rightObserver observe:self.rightObject];
    }
}

- (void)removeObservers {
    if (![self areKeypathsSet] || ![self areObjectsSet]) {
        return;
    }
    
    if (self.direction == BNDBindingDirectionLeftToRight ||
        self.direction == BNDBindingDirectionBoth) {
        [self.leftObserver unobserve:self.leftObject];
        self.leftObserver = nil;
    }
    
    if (self.direction == BNDBindingDirectionRightToLeft ||
        self.direction == BNDBindingDirectionBoth) {
        [self.rightObserver unobserve:self.rightObject];
        self.rightObserver = nil;
    }
}

- (BOOL)areObjectsSet {
    BOOL isLeftObject = _leftObject != nil;
    BOOL isRightObject = _rightObject != nil;
    return isLeftObject && isRightObject;
}

- (BOOL)areKeypathsSet {
    BOOL areKeypathsSet = _leftKeyPath != nil && _rightKeyPath != nil;
    return areKeypathsSet;
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if (self.isLocked) {
        return;
    }
    
    [self lock];
    
    id newObject = change[NSKeyValueChangeNewKey];
    if ([newObject isKindOfClass:[NSNull class]]) {
        newObject = nil;
    }
    
    if ([object isEqual:self.leftObject] && [self.leftKeyPath isEqualToString:keyPath]) {
        id transformedObject = [self.valueTransformer performSelector:[self transformSelector]
                                                           withObject:newObject];
        [self.rightObject setValue:transformedObject
                        forKeyPath:self.rightKeyPath];
    }
    else if ([object isEqual:self.rightObject] && [self.rightKeyPath isEqualToString:keyPath]) {
        id transformedObject = [self.valueTransformer performSelector:[self reverseTransformSelector]
                                                           withObject:newObject];
        [self.leftObject setValue:transformedObject
                   forKeyPath:self.leftKeyPath];
    }
    
    [self unlock];
}

- (void)lock {
    _locked = YES;
}

- (void)unlock {
    _locked = NO;
}

- (BOOL)isLocked {
    return _locked;
}

@end

#pragma clang diagnostic pop

@implementation BNDBindingKVOObserver

+ (instancetype)observerWithKeyPath:(NSString *)keyPath binding:(BNDBinding *)binding {
    return [[self alloc] initWithKeyPath:keyPath binding:binding];
}

- (instancetype)initWithKeyPath:(NSString *)keyPath binding:(BNDBinding *)binding {
    self = [super init];
    if (self) {
        _keyPath = keyPath.copy;
        _binding = binding;
    }
    return self;
}

- (void)observe:(id)observable {
    [observable addObserver:self
                 forKeyPath:self.keyPath
                    options:NSKeyValueObservingOptionNew
                    context:BNDBindingContext];
    [self addBindingForObject:observable];
    [self swizzleDeallocIfNeeded:observable];
}

- (void)unobserve:(id)observable {
    [observable removeObserver:self
                    forKeyPath:self.keyPath
                       context:BNDBindingContext];
    [self removeBindingForObject:observable];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if (context != BNDBindingContext) {
        return;
    }
    
    [self.binding observeValueForKeyPath:keyPath
                                ofObject:object
                                  change:change
                                 context:context];
}

- (void)addBindingForObject:(id)object {
    NSMutableSet *bindings = [self bindingsForObject:object];
    [bindings addObject:self];
}

- (void)removeBindingForObject:(id)object {
    NSMutableSet *bindings = [self bindingsForObject:object];
    [bindings removeObject:self];
}

- (NSMutableSet *)bindingsForObject:(id)object {
    NSMutableSet *set = objc_getAssociatedObject(object, &BNDBindingAssociatedBindingsKey);
    if (!set) {
        set = [NSMutableSet new];
        objc_setAssociatedObject(object, &BNDBindingAssociatedBindingsKey, set, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return set;
}

- (void)swizzleDeallocIfNeeded:(id)object {
    if (!object)
        return;
    @synchronized (BNDBindingObject_swizzledClasses) {
        Class class = [object class];
        if ([BNDBindingObject_swizzledClasses containsObject:class]) {
            return;
        }
        
        SEL deallocSelector = NSSelectorFromString(@"dealloc");
        Method deallocMethod = class_getInstanceMethod(class, deallocSelector);
        IMP deallocImplementation = method_getImplementation(deallocMethod);
        IMP newDeallocImplementation = imp_implementationWithBlock(^(void *obj) {
            @autoreleasepool {
                NSArray *bindings = [objc_getAssociatedObject((__bridge id)obj, &BNDBindingAssociatedBindingsKey) copy];
                NSObject *object = (__bridge id)(obj);
                for (BNDBindingKVOObserver *observer in bindings) {
                    [observer unobserve:object];
                    [observer.binding unbind];
                }
            }
            ((void (*)(void *, SEL))deallocImplementation)(obj, deallocSelector);
        });
        
        class_replaceMethod(class,
                            deallocSelector,
                            newDeallocImplementation,
                            method_getTypeEncoding(deallocMethod));
        
        [BNDBindingObject_swizzledClasses addObject:class];
    }
}

@end
