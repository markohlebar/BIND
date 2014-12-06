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
#import "BNDBindingTypes.h"

NSString *const BNDTableViewCellTouchUpInsideKeyPath = @"onTouchUpInside";
const void * BNDTableViewCellTouchUpInsideBindingKey = &BNDTableViewCellTouchUpInsideBindingKey;

@implementation _BNDTableViewCell (BNDBinding)

- (void)handleSpecialKeyPath:(NSString *)keyPath {
    if ([keyPath isEqualToString:BNDTableViewCellTouchUpInsideKeyPath]) {
        
    }
}

- (BNDBinding *)touchUpInsideBinding {
    BNDBinding *binding = objc_getAssociatedObject(self, BNDTableViewCellTouchUpInsideBindingKey);
    if (!binding) {
        NSString *BIND = nil;
#if TARGET_OS_IPHONE
        BIND = @"highlighted |-> onHighlighted";
#elif TARGET_OS_MAC
        BIND = @"backgroundStyle |-> onBackgroundStyle";
#endif
        binding = [BNDBinding bindingWithBIND:BIND];
        [binding bindLeft:self withRight:self];
        
        objc_setAssociatedObject(self,
                                 BNDTableViewCellTouchUpInsideBindingKey,
                                 binding,
                                 OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return binding;
}

#if TARGET_OS_IPHONE

- (void)setOnHighlighted:(BOOL)onHiglighted {
    if (onHiglighted) {
        [self willChangeValueForKey:BNDTableViewCellTouchUpInsideKeyPath];
        [self didChangeValueForKey:BNDTableViewCellTouchUpInsideKeyPath];
    }
}

#elif TARGET_OS_MAC
- (void)setOnBackgroundStyle:(NSBackgroundStyle)backgroundStyle

#endif

- (BNDTableViewCell *)onTouchUpInside {
    return self;
}

@end
