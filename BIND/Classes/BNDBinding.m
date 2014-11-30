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

@interface BNDBinding ()
@property (nonatomic, weak) id leftObject;
@property (nonatomic, weak) id rightObject;
@property (nonatomic, strong) NSString *leftKeyPath;
@property (nonatomic, strong) NSString *rightKeyPath;
@property (nonatomic) BNDBindingDirection direction;
@property (nonatomic) BNDBindingTransformDirection transformDirection;
@property (nonatomic, strong) NSValueTransformer *valueTransformer;
@property (nonatomic) BOOL shouldSetInitialValues;
@end

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

@implementation BNDBinding {
    BOOL _locked;
}

- (void)dealloc {
    [self unbind];
}

+ (BNDBinding *)bindingWithBIND:(NSString *)BIND {
    BNDBinding *binding = [BNDBinding new];
    binding.BIND = BIND;
    return binding;
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
       withRight:(id)rightObject; {
    [self unbind];
    
    self.leftObject = leftObject;
    self.rightObject = rightObject;
    
    [self bind];
}

- (void)bind {
    [self setInitialValues];
    [self setupObservers];
    [BNDSpecialKeyPathHandler handleSpecialKeyPathsForBinding:self];
}

- (void)unbind {
    [self removeObservers];
    
    self.leftObject = nil;
    self.rightObject = nil;
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
    if (![self areKeypathsSet]) {
        return;
    }
    
    if (self.direction == BNDBindingDirectionLeftToRight ||
        self.direction == BNDBindingDirectionBoth) {
        [self.leftObject addObserver:self
                          forKeyPath:self.leftKeyPath
                             options:NSKeyValueObservingOptionNew
                             context:NULL];
    }
    
    if (self.direction == BNDBindingDirectionRightToLeft ||
        self.direction == BNDBindingDirectionBoth) {
        [self.rightObject addObserver:self
                           forKeyPath:self.rightKeyPath
                              options:NSKeyValueObservingOptionNew
                              context:NULL];
    }
}

- (void)removeObservers {
    if (![self areKeypathsSet]) {
        return;
    }
    
    if (self.direction == BNDBindingDirectionLeftToRight ||
        self.direction == BNDBindingDirectionBoth) {
        [self.leftObject removeObserver:self forKeyPath:self.leftKeyPath];
    }
    
    if (self.direction == BNDBindingDirectionRightToLeft ||
        self.direction == BNDBindingDirectionBoth) {
        [self.rightObject removeObserver:self forKeyPath:self.rightKeyPath];
    }
}

- (BOOL)areKeypathsSet {
    return self.leftKeyPath != nil && self.rightKeyPath != nil;
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
