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
        self.modelCreator = model;
    }
    return self;
}

- (void)setCreateBinding:(BNDAction)createBinding {
    [self.modelCreator createBinding];
}

- (NSString *)identifier {
    return @"BNDBindingCreateCellView";
}

@end
