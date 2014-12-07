//
//  BNDBindingListViewModel.m
//  BINDPlugin
//
//  Created by Marko Hlebar on 29/11/2014.
//  Copyright (c) 2014 Marko Hlebar. All rights reserved.
//

#import "BNDBindingListViewModel.h"

@implementation BNDBindingListViewModel

+ (instancetype)viewModelWithModel:(NSArray *)rows {
    return [[self alloc] initWithModel:rows];
}

- (instancetype)initWithModel:(NSArray *)rows {
    self = [super init];
    if (self) {
        _rowViewModels = rows;
    }
    return self;
}

@end
