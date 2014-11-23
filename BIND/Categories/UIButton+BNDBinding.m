//
//  UIButton+BNDBinding.m
//  BIND
//
//  Created by Marko Hlebar on 20/11/2014.
//  Copyright (c) 2014 Marko Hlebar. All rights reserved.
//

#if TARGET_OS_IPHONE

#import "UIButton+BNDBinding.h"

NSString *const UIButtonTouchUpInsideKeyPath = @"onTouchUpInside";

@implementation UIButton (BNDBinding)

- (void)handleSpecialKeyPath:(NSString *)keyPath {
    if ([keyPath isEqual:UIButtonTouchUpInsideKeyPath]) {
        [self addTarget:self
                 action:@selector(touchUpInside:)
       forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)touchUpInside:(UIButton *)button {
    [self willChangeValueForKey:UIButtonTouchUpInsideKeyPath];
    [self didChangeValueForKey:UIButtonTouchUpInsideKeyPath];
}

- (UIButton *)onTouchUpInside {
    return self;
}

@end

#endif
