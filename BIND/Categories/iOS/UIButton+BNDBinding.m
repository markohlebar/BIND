//
//  UIButton+BNDBinding.m
//  BIND
//
//  Created by Marko Hlebar on 20/11/2014.
//  Copyright (c) 2014 Marko Hlebar. All rights reserved.
//

#if TARGET_OS_IPHONE

#import "UIButton+BNDBinding.h"

@implementation UIButton (BNDBinding)

- (void)handleSpecialKeyPath:(NSString *)keyPath {
    if ([keyPath isEqual:BNDBindingTouchUpInsideKeyPath]) {
        [self addTarget:self
                 action:@selector(setOnTouchUpInside:)
       forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)setOnTouchUpInside:(UIButton *)button {
    [self didChangeValueForKey:BNDBindingTouchUpInsideKeyPath];
}

- (UIButton *)onTouchUpInside {
    return self;
}

@end

#endif
