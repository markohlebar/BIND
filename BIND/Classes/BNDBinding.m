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

@interface BNDBinding()
@property (nonatomic, copy) NSString *keyPath;
@property (nonatomic, copy) NSString *otherKeyPath;
@property (nonatomic) BNDBindingInitialAssignment initialAssignment;
@end

@implementation BNDBinding {
    BOOL _locked;
}

- (void)dealloc {
    [self removeObservers];
}

+ (BNDBinding *)bindingWithObject:(id)object
                          keyPath:(NSString *)keyPath
                       withObject:(id)otherObject
                          keyPath:(NSString *)otherKeyPath {
    return [self bindingWithObject:object
                           keyPath:keyPath
                        withObject:otherObject
                           keyPath:otherKeyPath
                       transformer:[NSValueTransformer new]
                 initialAssignment:BNDBindingInitialAssignmentLeft];
}

+ (BNDBinding *)bindingWithObject:(id)object
                          keyPath:(NSString *)keyPath
                       withObject:(id)otherObject
                          keyPath:(NSString *)otherKeyPath
                      transformer:(NSValueTransformer *)transformer {
    return [self bindingWithObject:object
                           keyPath:keyPath
                        withObject:otherObject
                           keyPath:otherKeyPath
                       transformer:transformer
                 initialAssignment:BNDBindingInitialAssignmentLeft];
}

+ (BNDBinding *)bindingWithObject:(id)object
                          keyPath:(NSString *)keyPath
                       withObject:(id)otherObject
                          keyPath:(NSString *)otherKeyPath
                      transformer:(NSValueTransformer *)transformer
                initialAssignment:(BNDBindingInitialAssignment)initialAssignment {
    return [[BNDBinding alloc] initWithObject:object
                                      keyPath:keyPath
                                   withObject:otherObject
                                      keyPath:otherKeyPath
                                  transformer:transformer
                            initialAssignment:initialAssignment];
}

- (instancetype)initWithObject:(id)object
                       keyPath:(NSString *)keyPath
                    withObject:(id)otherObject
                       keyPath:(NSString *)otherKeyPath
                   transformer:(NSValueTransformer *)transformer
             initialAssignment:(BNDBindingInitialAssignment)initialAssignment {
    self = [super init];
    if (self) {
        _object = object;
        _keyPath = keyPath.copy;
        _otherObject = otherObject;
        _otherKeyPath = otherKeyPath.copy;
        _valueTransformer = transformer;
        _initialAssignment = initialAssignment;

        _locked = NO;
        
        [self setInitialValues];
        [self setupObservers];
    }
    return self;
}

- (void)setBIND:(NSString *)BIND {
    _BIND = BIND;
    _BIND = [_BIND stringByReplacingOccurrencesOfString:@" "
                                             withString:@""];
    _BIND = [_BIND stringByReplacingOccurrencesOfString:@"\n"
                                             withString:@""];
    [self parseKeyPaths:_BIND];
    
    if (self.object && self.otherObject) {
        [self setInitialValues];
        [self setupObservers];
    }
}

- (void)parseKeyPaths:(NSString *)bind {
    NSString *separator = nil;
    if ([bind rangeOfString:BNDBindingArrowRight].location != NSNotFound) {
        separator = BNDBindingArrowRight;
        self.initialAssignment = BNDBindingInitialAssignmentRight;
    }
    else if ([bind rangeOfString:BNDBindingArrowLeft].location != NSNotFound) {
        separator = BNDBindingArrowLeft;
        self.initialAssignment = BNDBindingInitialAssignmentLeft;
    }
    else if ([bind rangeOfString:BNDBindingArrowNone].location != NSNotFound) {
        separator = BNDBindingArrowNone;
        self.initialAssignment = BNDBindingInitialAssignmentNone;
    }
    else {
        NSAssert(NO, @"Couldn't find initial assignment direction. Check the BIND syntax manual for more info.");
    }
    
    NSArray *keyPaths = [_BIND componentsSeparatedByString:separator];
    NSAssert(keyPaths.count == 2, @"Couldn't find keyPaths. Check the BIND syntax manual for more info.");
    
    NSArray *keyPathAndTransformer = [keyPaths[1] componentsSeparatedByString:BNDBindingTransformerSeparator];
    self.keyPath = keyPaths[0];
    self.otherKeyPath = keyPathAndTransformer[0];
    
    NSAssert(self.keyPath.length > 0, @"Provide a valid keyPath. Check the BIND syntax manual for more info.");
    NSAssert(self.otherKeyPath.length > 0, @"Provide a valid otherKeyPath. Check the BIND syntax manual for more info.");

    [self parseTransformer:keyPathAndTransformer];
}

- (void)parseTransformer:(NSArray *)keyPathAndTransformer {
    if (keyPathAndTransformer.count == 2) {
        NSString *transformerClassName = keyPathAndTransformer[1];
        Class transformerClass = NSClassFromString(transformerClassName);
        NSString *assert = [NSString stringWithFormat:@"Non existing transformer class %@", transformerClassName];
        NSAssert(transformerClass != nil, assert);
        self.valueTransformer = [transformerClass new];
    }
    else {
        self.valueTransformer = [NSValueTransformer new];
    }
}

- (void)bindObject:(id)object
       otherObject:(id)otherObject; {
    [self removeObservers];
    
    _object = object;
    _otherObject = otherObject;
    
    [self setInitialValues];
    [self setupObservers];
}

- (void)unbind {
    [self removeObservers];
}

- (void)setInitialValues {
    if (self.initialAssignment == BNDBindingInitialAssignmentLeft) {
        id value = [self.otherObject valueForKeyPath:self.otherKeyPath];
        value = [_valueTransformer reverseTransformedValue:value];
        [self.object setValue:value forKeyPath:self.keyPath];
    }
    else if (self.initialAssignment == BNDBindingInitialAssignmentRight) {
        id value = [self.object valueForKeyPath:self.keyPath];
        value = [_valueTransformer transformedValue:value];
        [self.otherObject setValue:value forKeyPath:self.otherKeyPath];
    }
}

- (void)setupObservers {
    if (self.keyPath == nil || self.otherKeyPath == nil) {
        return;
    }
    
    [self.object addObserver:self
                  forKeyPath:self.keyPath
                     options:NSKeyValueObservingOptionNew
                     context:NULL];
    
    [self.otherObject addObserver:self
                       forKeyPath:self.otherKeyPath
                          options:NSKeyValueObservingOptionNew
                          context:NULL];
}

- (void)removeObservers {
    [self.object removeObserver:self forKeyPath:self.keyPath];
    [self.otherObject removeObserver:self forKeyPath:self.otherKeyPath];
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
    if ([object isEqual:self.object]) {
        id transformedObject = [self.valueTransformer transformedValue:newObject];
        [self.otherObject setValue:transformedObject
                        forKeyPath:self.otherKeyPath];
    }
    else if ([object isEqual:self.otherObject]) {
        id transformedObject = [self.valueTransformer reverseTransformedValue:newObject];
        [self.object setValue:transformedObject
                   forKeyPath:self.keyPath];
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
