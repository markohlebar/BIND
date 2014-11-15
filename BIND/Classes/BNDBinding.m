//
//  BNDBinding.m
//  BIND
//
//  Created by Marko Hlebar on 27/10/2014.
//  Copyright (c) 2014 Marko Hlebar. All rights reserved.
//

#import "BNDBinding.h"

static NSString *const BNDBindingArrowRight = @"->";
static NSString *const BNDBindingArrowLeft = @"<-";
static NSString *const BNDBindingArrowNone = @"<>";
static NSString *const BNDBindingTransformerSeparator = @"|";
static NSString *const BNDBindingTransformerDirectionModifier = @"!";

@interface BNDBinding()
@property (nonatomic, weak) id leftObject;
@property (nonatomic, weak) id rightObject;
@property (nonatomic, strong) NSString *leftKeyPath;
@property (nonatomic, strong) NSString *rightKeyPath;
@property (nonatomic) BNDBindingDirection direction;
@property (nonatomic) BNDBindingTransformDirection transformDirection;
@property (nonatomic, strong) NSValueTransformer *valueTransformer;
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

- (void)setBIND:(NSString *)BIND {
    _BIND = BIND;
    _BIND = [_BIND stringByReplacingOccurrencesOfString:@" "
                                             withString:@""];
    _BIND = [_BIND stringByReplacingOccurrencesOfString:@"\n"
                                             withString:@""];
    [self parseKeyPaths:_BIND];
    
    if (self.leftObject && self.rightObject) {
        [self setInitialValues];
        [self setupObservers];
    }
}

- (void)parseKeyPaths:(NSString *)bind {
    NSString *separator = nil;
    if ([bind rangeOfString:BNDBindingArrowRight].location != NSNotFound) {
        separator = BNDBindingArrowRight;
        self.direction = BNDBindingDirectionLeftToRight;
    }
    else if ([bind rangeOfString:BNDBindingArrowLeft].location != NSNotFound) {
        separator = BNDBindingArrowLeft;
        self.direction = BNDBindingDirectionRightToLeft;
    }
    else if ([bind rangeOfString:BNDBindingArrowNone].location != NSNotFound) {
        separator = BNDBindingArrowNone;
        self.direction = BNDBindingDirectionBoth;
    }
    else {
        NSAssert(NO, @"Couldn't find initial assignment direction. Check the BIND syntax manual for more info.");
    }
    
    NSArray *keyPaths = [_BIND componentsSeparatedByString:separator];
    NSAssert(keyPaths.count == 2, @"Couldn't find keyPaths. Check the BIND syntax manual for more info.");
    
    NSArray *keyPathAndTransformer = [keyPaths[1] componentsSeparatedByString:BNDBindingTransformerSeparator];
    self.leftKeyPath = keyPaths[0];
    self.rightKeyPath = keyPathAndTransformer[0];
    
    NSAssert(self.leftKeyPath.length > 0, @"Provide a valid keyPath. Check the BIND syntax manual for more info.");
    NSAssert(self.rightKeyPath.length > 0, @"Provide a valid otherKeyPath. Check the BIND syntax manual for more info.");

    [self parseTransformer:keyPathAndTransformer];
}

- (void)parseTransformer:(NSArray *)keyPathAndTransformer {
    if (keyPathAndTransformer.count == 2) {
        NSString *modifierAndTransformer = keyPathAndTransformer[1];
        NSString *transformerClassName = nil;
        NSRange modifierRange = [modifierAndTransformer rangeOfString:BNDBindingTransformerDirectionModifier];
        if (modifierRange.location != NSNotFound) {
            transformerClassName = [modifierAndTransformer stringByReplacingCharactersInRange:modifierRange
                                                                                   withString:@""];
            self.transformDirection = BNDBindingTransformDirectionRightToLeft;
        }
        else {
            transformerClassName = modifierAndTransformer;
        }
        
        Class transformerClass = NSClassFromString(transformerClassName);
        NSString *assert __attribute__((unused)) = [NSString stringWithFormat:@"Non existing transformer class %@", transformerClassName];
        NSAssert(transformerClass != nil, assert);
        
        self.valueTransformer = [transformerClass new];
    }
    else {
        self.valueTransformer = [NSValueTransformer new];
    }
}

- (void)bindLeft:(id)leftObject
       withRight:(id)rightObject; {
    [self bindLeft:leftObject withRight:rightObject setInitialValues:YES];
}

- (void)bindLeft:(id)leftObject
       withRight:(id)rightObject
setInitialValues:(BOOL)setInitialValues {
    [self unbind];
    
    self.leftObject = leftObject;
    self.rightObject = rightObject;
    
    if(setInitialValues) {
        [self setInitialValues];
    }
    [self setupObservers];
}

- (void)unbind {
    [self removeObservers];
    
    self.leftObject = nil;
    self.rightObject = nil;
}

- (void)setInitialValues {
    if (![self areKeypathsSet]) {
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
    if ([object isEqual:self.leftObject]) {
        id transformedObject = [self.valueTransformer performSelector:[self transformSelector]
                                                           withObject:newObject];
        [self.rightObject setValue:transformedObject
                        forKeyPath:self.rightKeyPath];
    }
    else if ([object isEqual:self.rightObject]) {
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
