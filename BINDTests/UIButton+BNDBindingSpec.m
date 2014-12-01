//
//  UIButton+BNDBindingSpec.m
//  BIND
//
//  Created by Marko Hlebar on 21/11/2014.
//  Copyright 2014 Marko Hlebar. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "UIButton+BNDBinding.h"

@interface UIButton (Testing)
- (void)touchUpInside:(UIButton *)button;
@end

SPEC_BEGIN(UIButton_BNDBindingSpec)

describe(@"UIButton+BNDBinding", ^{
    __block UIButton *button = nil;
    __block NSObject *observer = nil;
    
    beforeEach(^{
//        button = [UIButton buttonWithType:UIButtonTypeSystem];
//        observer = [NSObject new];
//        
//        [button addObserver:observer
//                forKeyPath:@"onTouchUpInside"
//                    options:0
//                    context:NULL];
    });
    
    context(@"Given a button", ^{
        it(@"Should fire a KVO notification when touched", ^{

        });
    });
});

SPEC_END
