//
//  BNDTableViewCell+BNDBinding.m
//  BIND
//
//  Created by Marko Hlebar on 06/12/2014.
//  Copyright (c) 2014 Marko Hlebar. All rights reserved.
//

#import "BNDTableViewCell+BNDBinding.h"
#import <objc/runtime.h>
#import "BNDBinding.h"

NSString * const BNDTableViewCellTouchUpInsideBindingKeyPath = @"BNDTableViewCellTouchUpInsideBindingKey";

@implementation _BNDTableViewCell (BNDBinding)

- (void)handleSpecialKeyPath:(NSString *)keyPath {
    if ([keyPath isEqualToString:BNDBindingTouchUpInsideKeyPath]) {
        [self setupTouchUpInsideBinding];
    }
}

- (void)setupTouchUpInsideBinding {
#if TARGET_OS_IPHONE
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTouchUpInside:)];
    [tapGestureRecognizer setCancelsTouchesInView:NO];
    [self addGestureRecognizer:tapGestureRecognizer];
    
#elif TARGET_OS_MAC
    NSString *BIND = @"backgroundStyle !~> onBackgroundStyle";
    BNDBinding *binding  = [BNDBinding bindingWithBIND:BIND];
    [binding bindLeft:self withRight:self];
    
    objc_setAssociatedObject(self,
                             &BNDTableViewCellTouchUpInsideBindingKeyPath,
                             binding,
                             OBJC_ASSOCIATION_RETAIN);
#endif
}

#if TARGET_OS_IPHONE

- (void)didTouchUpInside:(UIGestureRecognizer *)gestureRecognizer {
    [self setOnTouchUpInside:self];
}

#elif TARGET_OS_MAC
- (void)setOnBackgroundStyle:(NSBackgroundStyle)backgroundStyle {
    if (backgroundStyle == NSBackgroundStyleDark) {
        [self setOnTouchUpInside:self];
    }
}
#endif

- (void)setOnTouchUpInside:(_BNDTableViewCell *)cell {
    [self didChangeValueForKey:BNDBindingTouchUpInsideKeyPath];
}

- (_BNDTableViewCell *)onTouchUpInside {
    return self;
}

@end
