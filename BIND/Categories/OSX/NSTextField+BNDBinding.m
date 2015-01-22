//
//  NSTextField+BNDBinding.m
//  BIND
//
//  Created by Marko Hlebar on 13/12/2014.
//  Copyright (c) 2014 Marko Hlebar. All rights reserved.
//

#import "NSTextField+BNDBinding.h"
#import <objc/runtime.h>

NSString *const NSTextFieldTextKeyPath = @"text";
const void * NSTextFieldForwardingDelegateKey = &NSTextFieldForwardingDelegateKey;

@interface NSTextField (Delegate) <NSTextFieldDelegate>
@end

@implementation NSTextField (BNDBinding)

- (void)handleSpecialKeyPath:(NSString *)keyPath {
    if ([keyPath isEqualToString:NSTextFieldTextKeyPath]) {
//        [self setBnd_ForwardingDelegate:self.delegate];
        self.delegate = self;
    }
}

- (void)controlTextDidChange:(NSNotification *)notification {
    NSTextField *textField = [notification object];
    if (textField == self) {
        [self willChangeValueForKey:NSTextFieldTextKeyPath];
        [self didChangeValueForKey:NSTextFieldTextKeyPath];
        
//        if ([[self bnd_forwardingDelegate] respondsToSelector:@selector(controlTextDidChange:)]) {
//            [[self bnd_forwardingDelegate] controlTextDidChange:notification];
//        }
    }
}

- (void)setText:(NSString *)text {
    self.stringValue = text;
}

- (NSString *)text {
    return self.stringValue;
}

#pragma mark - Delegate forwarding

//-(BOOL)respondsToSelector:(SEL)aSelector {
//    if ([[self bnd_forwardingDelegate] respondsToSelector:aSelector]) {
//        return YES;
//    }
//    return [super respondsToSelector:aSelector];
//}
//
//-(id)forwardingTargetForSelector:(SEL)aSelector {
//    if ([[self bnd_forwardingDelegate] respondsToSelector:aSelector]) {
//        return [self bnd_forwardingDelegate];
//    }
//    return [super forwardingTargetForSelector:aSelector];
//}
//
//- (void)setBnd_ForwardingDelegate:(id)delegate {
//    objc_setAssociatedObject(self, NSTextFieldForwardingDelegateKey, delegate, OBJC_ASSOCIATION_ASSIGN);
//}
//
//- (id)bnd_forwardingDelegate {
//    return objc_getAssociatedObject(self, NSTextFieldForwardingDelegateKey);
//}

@end
