//
//  BNDSelectorBinding.m
//  BIND
//
//  Created by Marko Hlebar on 18/04/2015.
//  Copyright (c) 2015 Marko Hlebar. All rights reserved.
//

#import "BNDSelectorBinding.h"

@implementation BNDSelectorBinding

- (void)bindLeft:(id)leftObject withRight:(id)rightObject {
    if (self.selector) {
        [self assertObject:rightObject respondsToSelector:self.selector];
    }
    [super bindLeft:leftObject withRight:rightObject];
}

- (void)assertObject:(id)object respondsToSelector:(SEL)selector {
    NSAssert([object respondsToSelector:selector], @"object needs to respond to selector");
}

@end
