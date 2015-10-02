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
#import "BNDAsyncValueTransformer.h"
#import "BNDMacros.h"

static NSMutableSet *BNDBindingObject_swizzledClasses = nil;
static NSPointerArray *BNDBindingObject_bindings = nil;

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

@property (nonatomic) SEL transformSelector;
@property (nonatomic) SEL reverseTransformSelector;

@property (nonatomic, getter=isAsynchronousMode) BOOL asynchronousMode;

@property (nonatomic, strong) id voidKeyPath;

@property (nonatomic, copy) BNDBindingTransformValueBlock transformBlock;
@property (nonatomic, copy) BNDBindingObservationBlock observationBlock;

@property (nonatomic, copy) NSString *operator;

+ (NSArray *)allBindings;
@end

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

@implementation BNDBinding {
    BOOL _lockedObservation;
}

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        BNDBindingObject_swizzledClasses = [NSMutableSet new];
        BNDBindingObject_bindings = [[NSPointerArray alloc] initWithOptions:NSPointerFunctionsWeakMemory];
    });
}

+ (NSArray *)allBindings {
    return BNDBindingObject_bindings.allObjects;
}

- (void)dealloc {
    [self unbind];
}

+ (BNDBinding *)bindingWithBIND:(NSString *)BIND
                 transformBlock:(BNDBindingTransformValueBlock)transformBlock {
    BNDBinding *binding = [self new];
    binding.BIND = BIND;
    binding.transformBlock = transformBlock;
    return binding;
}

+ (BNDBinding *)bindingWithBIND:(NSString *)BIND {
    return [self bindingWithBIND:BIND
                  transformBlock:nil];
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

- (BNDBinding *)transform:(BNDBindingTransformValueBlock)transformBlock {
    self.transformBlock = transformBlock;
    [self setValues];
    return self;
}

- (instancetype)observe:(BNDBindingObservationBlock)observationBlock {
    self.observationBlock = observationBlock;
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
    self.asynchronousMode = [definition.valueTransformer isKindOfClass:[BNDAsyncValueTransformer class]];
    self.operator = definition.operator;
    
    NSAssert(!(self.asynchronousMode && self.direction == BNDBindingDirectionBoth), @"Bidirectional asynchronous binding not supported");
    
    [self prepareTransformSelectorsWithAsynchronousMode:self.isAsynchronousMode
                                     transformDirection:self.transformDirection];
}

- (void)bindLeft:(id)leftObject
       withRight:(id)rightObject {
    [self unbind];
    
    self.leftObject = leftObject;
    self.rightObject = rightObject;
    
    [self bind];
}

- (void)bind {
    if (![self areKeypathsSet] || ![self areObjectsSet]) {
        return;
    }
    
    [self setInitialValues];
    [self setupObservers];
    [BNDSpecialKeyPathHandler handleSpecialKeyPathsForBinding:self];
    
    [BNDBindingObject_bindings addPointer:(__bridge void *)(self)];
    
    BNDLog(@"%@", [self debugDescription]);
}

- (void)unbind {
    if (self.leftObject == nil && self.rightObject == nil) {
        return;
    }
    
    BNDLog(@"%@", [self debugDescription]);
    
    [self removeObservers];
    
    self.leftObject = nil;
    self.rightObject = nil;
    
    [BNDBindingObject_bindings compact];
}

- (void)setInitialValues {
    if (!self.shouldSetInitialValues) {
        return;
    }
    
    [self setValues];
}

- (void)setValues {
    if (self.direction == BNDBindingDirectionLeftToRight ||
        self.direction == BNDBindingDirectionBoth) {
        id value = [self.leftObject valueForKeyPath:self.leftKeyPath];
        [self setRightObjectValue:value];
    }
    else if (self.direction == BNDBindingDirectionRightToLeft) {
        id value = [self.rightObject valueForKeyPath:self.rightKeyPath];
        [self setLeftObjectValue:value];
    }
}

- (void)setLeftObjectValue:(id)value {
    if (self.isAsynchronousMode) {
        __weak typeof(self) weakSelf = self;
        void (^asyncTransformBlock)(id, id) = ^(id value, id transformedValue) {
            [weakSelf.leftObject setValue:transformedValue
                               forKeyPath:weakSelf.leftKeyPath];
        };
        
        [self.valueTransformer performSelector:self.reverseTransformSelector
                                    withObject:value
                                    withObject:asyncTransformBlock];
    }
    else {
        value = [self.valueTransformer performSelector:self.reverseTransformSelector
                                            withObject:value];
        if (self.transformBlock) {
            __weak id object = self.rightObject;
            value = self.transformBlock(object, value);
        }
        [self.leftObject setValue:value forKeyPath:self.leftKeyPath];
    }
}

- (void)setRightObjectValue:(id)value {
    if (self.isAsynchronousMode) {
        __weak typeof(self) weakSelf = self;
        void (^asyncTransformBlock)(id, id) = ^(id value, id transformedValue) {
            [weakSelf.rightObject setValue:transformedValue
                                forKeyPath:weakSelf.rightKeyPath];
        };
        
        [self.valueTransformer performSelector:self.transformSelector
                                    withObject:value
                                    withObject:asyncTransformBlock];
    }
    else {
        value = [self.valueTransformer performSelector:self.transformSelector
                                            withObject:value];
        if (self.transformBlock) {
            __weak id object = self.leftObject;
            value = self.transformBlock(object, value);
        }
        [self.rightObject setValue:value forKeyPath:self.rightKeyPath];
    }
}

- (void)prepareTransformSelectorsWithAsynchronousMode:(BOOL)asynchronousMode
                                   transformDirection:(BNDBindingTransformDirection)transformDirection {
	SEL transformSelector = asynchronousMode ?
	    @selector(asyncTransformValue:transformBlock:) :
	    @selector(transformedValue:);
    
	SEL reverseTransformSelector = asynchronousMode ?
	    @selector(reverseAsyncTransformValue:transformBlock:) :
	    @selector(reverseTransformedValue:);

	BOOL isForwardDirection = (transformDirection == BNDBindingTransformDirectionLeftToRight);
	self.transformSelector = isForwardDirection ? transformSelector : reverseTransformSelector;
	self.reverseTransformSelector = isForwardDirection ? reverseTransformSelector : transformSelector;
}

- (void)setupObservers {
    [self removeObservers];
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
    if (self.isObservationLocked) {
        return;
    }
    
    [self lockObservation];
    
    id newObject = [object valueForKeyPath:keyPath];
    if ([newObject isKindOfClass:[NSNull class]]) {
        newObject = nil;
    }
    
    if ([object isEqual:self.leftObject] && [self.leftKeyPath isEqualToString:keyPath]) {
        [self setRightObjectValue:newObject];
    }
    else if ([object isEqual:self.rightObject] && [self.rightKeyPath isEqualToString:keyPath]) {
        [self setLeftObjectValue:newObject];
    }
    
    if (self.observationBlock) {
        self.observationBlock(object, newObject, change);
    }
    
    [self unlockObservation];
}

- (void)lockObservation {
    _lockedObservation = YES;
}

- (void)unlockObservation {
    _lockedObservation = NO;
}

- (BOOL)isObservationLocked {
    return _lockedObservation;
}

- (NSString *)debugDescription {
    return [NSString stringWithFormat:@"%@ . %@ %@ %@ . %@ | %@", self.leftObject, self.leftKeyPath, self.operator, self.rightObject, self.rightKeyPath, self.valueTransformer];
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
    if (!observable) {
        return;
    }
    [observable addObserver:self
                 forKeyPath:self.keyPath
                    options:NSKeyValueObservingOptionNew
                    context:BNDBindingContext];
    [self addBindingForObject:observable];
    [self swizzleDeallocIfNeeded:observable];
}

- (void)unobserve:(id)observable {
    if (!observable) {
        return;
    }
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

@implementation BNDBinding (Debug)

+ (NSString *)allDebugDescription {
    NSMutableString *bindingsString = [NSMutableString stringWithString:@"BINDINGS {\n"];
    [BNDBindingObject_bindings.allObjects enumerateObjectsUsingBlock:^(BNDBinding *binding, NSUInteger idx, BOOL * stop) {
        [bindingsString appendFormat:@"%@\n", binding.debugDescription];
    }];
    [bindingsString appendFormat:@"} (%lu bindings)\n", (unsigned long)BNDBindingObject_bindings.count];
    return bindingsString;
}

static BOOL BNDBindingDebugEnabled;
+ (void)setDebugEnabled:(BOOL)enabled {
    BNDBindingDebugEnabled = enabled;
}

+ (BOOL)debugEnabled {
    return BNDBindingDebugEnabled;
}

@end
