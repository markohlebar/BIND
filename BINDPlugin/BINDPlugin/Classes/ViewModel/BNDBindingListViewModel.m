//
//  BNDBindingListViewModel.m
//  BINDPlugin
//
//  Created by Marko Hlebar on 29/11/2014.
//  Copyright (c) 2014 Marko Hlebar. All rights reserved.
//

#import "BNDBindingListViewModel.h"
#import "BNDBindingDefinition.h"
#import "BNDBindingCellViewModel.h"

@implementation BNDBindingListViewModel

+ (instancetype)viewModelWithModel:(NSArray *)bindings {
    return [[self alloc] initWithModel:bindings];
}

- (instancetype)initWithModel:(NSArray *)bindings {
    self = [super init];
    if (self) {
        self.rowViewModels = [self createRowViewModelsForBindings:bindings];
    }
    return self;
}

- (NSArray *)createRowViewModelsForBindings:(NSArray *)bindings {
    NSMutableArray *viewModels = [NSMutableArray new];
    for (BNDBindingDefinition *definition in bindings) {
        BNDBindingCellViewModel *viewModel = [BNDBindingCellViewModel viewModelWithModel:definition];
        [viewModels addObject:viewModel];
    }
    return viewModels.copy;
}

- (void)setCreateBinding:(id)createBinding {
    
}

@end
