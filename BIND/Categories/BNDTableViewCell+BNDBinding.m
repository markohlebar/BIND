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
    NSString *BIND = nil;
#if TARGET_OS_IPHONE
    BIND = @"highlighted !-> onHighlighted";
#elif TARGET_OS_MAC
    BIND = @"backgroundStyle !-> onBackgroundStyle";
#endif
    BNDBinding *binding  = [BNDBinding bindingWithBIND:BIND];
    [binding bindLeft:self withRight:self];
    
    objc_setAssociatedObject(self,
                             &BNDTableViewCellTouchUpInsideBindingKeyPath,
                             binding,
                             OBJC_ASSOCIATION_RETAIN);    
}

#if TARGET_OS_IPHONE

- (void)setOnHighlighted:(BOOL)onHighlighted {
    if (onHighlighted) {
        [self setOnTouchUpInside:self];
    }
}

- (BOOL)onHighlighted {
    return self.highlighted;
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
