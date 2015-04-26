//
//  UIBarButtonItem+BNDBinding.m
//  BIND
//
//  Created by Marko Hlebar on 25/04/2015.
//  Copyright (c) 2015 Marko Hlebar. All rights reserved.
//

#if TARGET_OS_IPHONE

#import "UIBarButtonItem+BNDBinding.h"

@implementation UIBarButtonItem (BNDBinding)

- (void)handleSpecialKeyPath:(NSString *)keyPath {
    if ([keyPath isEqual:BNDBindingTouchUpInsideKeyPath]) {
        [self setTarget:self];
        [self setAction:@selector(setOnTouchUpInside:)];
    }
}

- (void)setOnTouchUpInside:(UIButton *)button {
    [self didChangeValueForKey:BNDBindingTouchUpInsideKeyPath];
}

- (UIBarButtonItem *)onTouchUpInside {
    return self;
}

@end

#endif
