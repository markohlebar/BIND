//
//  BNDBindingCreateCellView.m
//  BINDPlugin
//
//  Created by Marko Hlebar on 06/12/2014.
//  Copyright (c) 2014 Marko Hlebar. All rights reserved.
//

#import "BNDBindingCreateCellView.h"
#import "BNDTableViewCell+BNDBinding.h"

@implementation BNDBindingCreateCellView

- (void)awakeFromNib {
    [self loadBindings];
}

- (void)loadBindings {
    BNDBinding *binding = [BNDBinding bindingWithBIND:@"onTouchUpInside !-> viewModel.createBinding"];
    self.bindings = @[binding];
}

- (void)prepareForReuse {
    [self animateIn];
}

- (void)animateIn {
    self.alphaValue = 0;
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        context.duration = 0.5;
        self.animator.alphaValue = 1;
    }
                        completionHandler:nil];
}

@end
