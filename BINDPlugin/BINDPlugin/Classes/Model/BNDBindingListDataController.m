//
//  BNDBindingListDataController.m
//  BINDPlugin
//
//  Created by Marko Hlebar on 29/11/2014.
//  Copyright (c) 2014 Marko Hlebar. All rights reserved.
//

#import "BNDBindingListDataController.h"
#import "BNDBindingListViewModel.h"
#import "BNDInterfaceBuilderWriter.h"
#import "BNDBindingDefinitionFactory.h"

@implementation BNDBindingListDataController {
    BNDInterfaceBuilderWriter *_bindingWriter;
    BNDBindingDefinitionFactory *_bindingFactory;
}

- (void)updateWithContext:(NSURL *)xibURL
        viewModelsHandler:(BNDViewModelsBlock)viewModelsHandler {
    
    _bindingWriter = [BNDInterfaceBuilderWriter writerWithXIBPathURL:xibURL];
    [_bindingWriter reloadBindings:nil];
    
    _bindingFactory = [BNDBindingDefinitionFactory factoryWithBindings:_bindingWriter.bindings];
    
    BNDBindingListViewModel *viewModel = [BNDBindingListViewModel viewModelWithModel:_bindingWriter.bindings];
    viewModelsHandler(@[viewModel], nil);
}

@end
