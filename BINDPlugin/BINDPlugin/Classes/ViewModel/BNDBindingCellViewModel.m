//
//  BNDBindingCellViewModel.m
//  BINDPlugin
//
//  Created by Marko Hlebar on 29/11/2014.
//  Copyright (c) 2014 Marko Hlebar. All rights reserved.
//

#import "BNDBindingCellViewModel.h"
#import "BNDBindingDefinition.h"

@interface BNDBindingCellViewModel ()
@property (nonatomic, strong) BNDBindingDefinition *binding;
@end

@implementation BNDBindingCellViewModel

+ (instancetype)viewModelWithModel:(BNDBindingDefinition *)model {
    return [[self alloc] initWithModel:model];
}

- (instancetype)initWithModel:(BNDBindingDefinition *)model {
    self = [super init];
    if (self) {
        _binding = model;
    }
    return self;
}

- (void)setBIND:(NSString *)BIND {
    _binding.BIND = BIND;
}

- (NSString *)BIND {
    return _binding.BIND;
}

@end
