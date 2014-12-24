//
//  BNDBindingCreateCellViewModel.m
//  BINDPlugin
//
//  Created by Marko Hlebar on 06/12/2014.
//  Copyright (c) 2014 Marko Hlebar. All rights reserved.
//

#import "BNDBindingCreateCellViewModel.h"

@implementation BNDBindingCreateCellViewModel

+ (instancetype)viewModelWithModel:(id)model {
    return [[self alloc] initWithModel:model];
}

- (instancetype)initWithModel:(id)model {
    self = [super init];
    if (self) {
    }
    return self;
}

- (NSString *)identifier {
    return @"BNDBindingCreateCellView";
}

@end
