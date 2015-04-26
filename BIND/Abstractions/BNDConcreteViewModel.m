//
//  BNDConcreteViewModel.m
//  BIND
//
//  Created by Marko Hlebar on 22/04/2015.
//  Copyright (c) 2015 Marko Hlebar. All rights reserved.
//

#import "BNDConcreteViewModel.h"
#import "BNDBinding.h"
#import "NSObject+NODE.h"

@implementation BNDViewModel

+ (instancetype)viewModelWithModel:(id)model {
    return [[self alloc] initWithModel:model];
}

- (instancetype)initWithModel:(id)model {
    if (self = [super init]) {
        _model = model;
        [self bindings];
    }
    return self;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        [self bindings];
    }
    return self;
}

- (NSString *)identifier {
    return nil;
}

- (void)addChild:(BNDViewModel *)child {
    [self node_addChild:child];
}

- (void)removeChild:(BNDViewModel *)child {
    [self node_removeChild:child];
}

- (void)removeAllChildren {
    [self node_removeAllChildren];
}

- (void)setChildren:(NSArray *)children {
    [self node_removeAllChildren];
    [self node_addChildren:children];
}

- (NSArray *)children {
    return self.node_children;
}

@end
