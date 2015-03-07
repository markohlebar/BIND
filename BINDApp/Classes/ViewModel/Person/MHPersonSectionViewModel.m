//
//  MHPersonSectionViewModel.m
//  MVVM
//
//  Created by Marko Hlebar on 02/11/2014.
//  Copyright (c) 2014 Marko Hlebar. All rights reserved.
//

#import "MHPersonSectionViewModel.h"

@implementation MHPersonSectionViewModel {
}

+ (instancetype)viewModelWithModel:(id)model {
    return [[self alloc] initWithModel:model];
}

- (instancetype)initWithModel:(id)model {
    self = [super init];
    if (self) {
        _rowViewModels = [model copy];
    }
    return self;
}

- (NSString *)identifier {
    return @"PersonSection";
}

- (CGFloat)cellHeight {
    return 30;
}

@end
