//
//  BNDBindingCreateCellView.m
//  BINDPlugin
//
//  Created by Marko Hlebar on 06/12/2014.
//  Copyright (c) 2014 Marko Hlebar. All rights reserved.
//

#import "BNDBindingCreateCellView.h"

@implementation BNDBindingCreateCellView

- (void)awakeFromNib {
    [self loadBindings];
}

- (void)loadBindings {
    BNDBinding *binding = [BNDBinding bindingWithBIND:@"onTouchUpInside !-> viewModel.createBinding"];
    self.bindings = @[binding];
}

@end
