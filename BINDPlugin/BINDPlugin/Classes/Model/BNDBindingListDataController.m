//
//  BNDBindingListDataController.m
//  BINDPlugin
//
//  Created by Marko Hlebar on 29/11/2014.
//  Copyright (c) 2014 Marko Hlebar. All rights reserved.
//

#import "BNDBindingListDataController.h"
#import "BNDInterfaceBuilderWriter.h"
#import "BNDBindingDefinitionFactory.h"
#import "BNDBindingCreateCellViewModel.h"
#import "BNDBindingCellViewModel.h"
#import "BNDBindingListViewModel.h"

@interface BNDBindingListDataController () <BNDInterfaceBuilderWriterDelegate>
@property (nonatomic, copy) BNDViewModelsBlock viewModelsHandler;
@end

@implementation BNDBindingListDataController

- (void)updateWithContext:(NSURL *)xibURL
        viewModelsHandler:(BNDViewModelsBlock)viewModelsHandler {
    self.viewModelsHandler = viewModelsHandler;
    
    NSError *error = nil;
    _bindingWriter = [BNDInterfaceBuilderWriter writerWithXIBPathURL:xibURL];
    _bindingWriter.delegate = self;
    NSArray *bindings = [_bindingWriter reloadBindings:&error];
    
    if (error) {
        self.viewModelsHandler(nil, error);
    }

    [self updateViewModelWithBindings:bindings];
}

- (BNDBindingListViewModel *)listViewModelForBindings:(NSArray *)bindings {
    
    NSMutableArray *rows = [self rowViewModelsForBindings:bindings].mutableCopy;
    
    BNDBindingCreateCellViewModel *createViewModel = [BNDBindingCreateCellViewModel viewModelWithModel:_bindingWriter];
    [rows addObject:createViewModel];
    
    return [BNDBindingListViewModel viewModelWithModel:rows.copy];
}

- (NSArray *)rowViewModelsForBindings:(NSArray *)bindings {
    NSMutableArray *viewModels = [NSMutableArray new];
    for (BNDBindingDefinition *definition in bindings) {
        BNDBindingCellViewModel *viewModel = [BNDBindingCellViewModel viewModelWithModel:definition];
        [viewModels addObject:viewModel];
    }
    
    return viewModels.copy;
}

- (void)updateViewModelWithBindings:(NSArray *)bindings {
    BNDBindingListViewModel *viewModel = [self listViewModelForBindings:bindings];
    self.viewModelsHandler(@[viewModel], nil);
}

#pragma mark = Writer Delegate

- (void)writer:(id)writer didUpdateWithBindings:(NSArray *)bindings {
    if (writer == _bindingWriter) {
        [self updateViewModelWithBindings:bindings];
    }
}

@end
