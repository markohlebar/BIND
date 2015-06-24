//
//  UIButton+BNDBinding.m
//  BIND
//
//  Created by Ben Clayton on 12/4/2015.
//

#if TARGET_OS_IPHONE

#import "UITextField+BNDBinding.h"
#import "BNDSpecialKeyPathHandling.h"

@implementation UITextField (BNDBinding)
- (void)handleSpecialKeyPath:(NSString *)keyPath {
    if ([keyPath isEqual:BNDBindingEditingChangedKeyPath]) {
        [self addTarget:self
                 action:@selector(setOnEditingChanged:)
       forControlEvents:UIControlEventEditingChanged];
    }
}

- (void)setOnEditingChanged:(NSString *)string {
    [self didChangeValueForKey:BNDBindingEditingChangedKeyPath];
}

- (NSString *)onEditingChanged {
    return self.text;
}
@end

#endif