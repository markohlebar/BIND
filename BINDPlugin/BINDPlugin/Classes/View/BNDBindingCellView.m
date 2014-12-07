//
//  BNDBindingCellView.m
//  BINDPlugin
//
//  Created by Marko Hlebar on 29/11/2014.
//  Copyright (c) 2014 Marko Hlebar. All rights reserved.
//

#import "BNDBindingCellView.h"
#import "BIND.h"

@interface BNDBindingCellView ()
@property (weak) IBOutlet NSTextField *textField;
@end

@implementation BNDBindingCellView

- (void)awakeFromNib {
    [self loadBindings];
}

- (void)loadBindings {
    BNDBinding *binding = [BNDBinding bindingWithBIND:@"viewModel.BIND <> textField.stringValue | BNDNilToEmptyStringTransformer"];
    self.bindings = @[binding];
}

@end
