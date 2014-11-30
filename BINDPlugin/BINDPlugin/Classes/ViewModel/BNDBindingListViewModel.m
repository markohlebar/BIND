//
//  BNDBindingListViewModel.m
//  BINDPlugin
//
//  Created by Marko Hlebar on 29/11/2014.
//  Copyright (c) 2014 Marko Hlebar. All rights reserved.
//

#import "BNDBindingListViewModel.h"

@implementation BNDBindingListViewModel

+ (instancetype)viewModelWithModel:(id)model {
    return [[self alloc] initWithModel:model];
}

- (instancetype)initWithModel:(id)model {
    self = [super init];
    if (self) {
        self.rowViewModels = @[[NSObject new]];
    }
    return self;
}

@end
