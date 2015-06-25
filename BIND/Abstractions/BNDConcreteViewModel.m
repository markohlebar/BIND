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

@interface BNDViewModel ()
@property (nonatomic, strong) NSMutableArray *mutableChildren;
@end

@implementation BNDViewModel
@synthesize bindings = _bindings;

+ (instancetype)viewModelWithModel:(id)model {
    return [[self alloc] initWithModel:model];
}

- (id)initWithModel:(id)model {
    if (self = [super init]) {
        _model = model;
        [self bindings];
        [self loadMutableChildren];
    }
    return self;
}

- (NSString *)identifier {
    return nil;
}

- (void)loadMutableChildren {
    if (!_mutableChildren) {
        _mutableChildren = [NSMutableArray new];
        [self node_setMutableChildren:_mutableChildren];
    }
}

- (void)addChild:(BNDViewModel *)child {
    NSParameterAssert([child isKindOfClass:[BNDViewModel class]]);
    [self node_addChild:child];
}

- (void)removeChild:(BNDViewModel *)child {
    [self node_removeChild:child];
}

- (void)removeAllChildren {
    [self node_removeAllChildren];
}

- (NSArray *)children {
    return self.node_children;
}

@end
