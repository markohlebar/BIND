//
//  BNDConcreteViewModel.m
//  BIND
//
//  Created by Marko Hlebar on 22/04/2015.
//  Copyright (c) 2015 Marko Hlebar. All rights reserved.
//

#import "BNDConcreteViewModel.h"
#import "BNDBinding.h"

@implementation BNDViewModel

+ (instancetype)viewModelWithModel:(id)model {
    return [[self alloc] initWithModel:model];
}

- (id)initWithModel:(id)model {
    if (self = [super init]) {
        _model = model;
        [self bindings];
    }
    return self;
}

- (NSString *)identifier {
    return nil;
}

@end
