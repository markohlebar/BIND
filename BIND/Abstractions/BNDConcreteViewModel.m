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
        self.model = model;
    }
    return self;
}

- (void)setModel:(id)model {
    _model = model;
    
    for (BNDBinding *binding in self.bindings) {
        [binding bindLeft:model withRight:self];
    }
}

- (NSString *)identifier {
    return nil;
}

@end
