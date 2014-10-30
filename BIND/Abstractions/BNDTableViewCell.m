//
//  BNDTableViewCell.m
//  BIND
//
//  Created by Marko Hlebar on 27/10/2014.
//  Copyright (c) 2014 Marko Hlebar. All rights reserved.
//

#import "BNDTableViewCell.h"
#import "BNDBinding.h"

@implementation BNDTableViewCell

- (void)updateWithViewModel:(id <BNDViewModel> )viewModel {
    for (BNDBinding *binding in self.bindings) {
        [binding bindObject:self otherObject:viewModel];
    }
}

@end
