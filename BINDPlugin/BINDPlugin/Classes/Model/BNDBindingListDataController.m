//
//  BNDBindingListDataController.m
//  BINDPlugin
//
//  Created by Marko Hlebar on 29/11/2014.
//  Copyright (c) 2014 Marko Hlebar. All rights reserved.
//

#import "BNDBindingListDataController.h"
#import "BNDBindingListViewModel.h"

@implementation BNDBindingListDataController

- (void)updateWithContext:(id)context
        viewModelsHandler:(BNDViewModelsBlock)viewModelsHandler {
    BNDBindingListViewModel *viewModel = [BNDBindingListViewModel viewModelWithModel:nil];
    viewModelsHandler(viewModel, nil);
}

@end
