//
//  BNDBindingSpecialKeyPathsHandlerSpec.m
//  BIND
//
//  Created by Marko Hlebar on 21/11/2014.
//  Copyright 2014 Marko Hlebar. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import <UIKit/UIKit.h>
#import "BNDBindingSpecialKeyPathsHandler.h"
#import "BNDBinding.h"
#import "BNDSpecialKeyPathHandling.h"

@interface TestViewController : UIViewController
@property (nonatomic) UIButton *button;
@property (nonatomic) UIButton *button2;
@end

@implementation TestViewController

- (UIButton *)button {
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeSystem];
    }
    return _button;
}

- (UIButton *)button2 {
    if (!_button2) {
        _button2 = [UIButton buttonWithType:UIButtonTypeSystem];
    }
    return _button2;
}

@end

SPEC_BEGIN(BNDBindingSpecialKeyPathsHandlerSpec)

describe(@"BNDBindingSpecialKeyPathsHandler", ^{
    
    __block BNDBinding *binding = nil;
    
    beforeEach(^{
        binding = [BNDBinding nullMock];
    });
    
    context(@"when handling an event with UIButton", ^{
        it(@"should look for onTouchUpInside and setup the listener", ^{
            
            TestViewController *viewController = [TestViewController new];

            [binding stub:@selector(leftObject) andReturn:viewController];
            [binding stub:@selector(leftKeyPath) andReturn:@"button.onTouchUpInside"];
            
            [binding stub:@selector(rightObject) andReturn:viewController];
            [binding stub:@selector(rightKeyPath) andReturn:@"button2.onTouchUpInside"];

            [[viewController.button should] receive:@selector(handleSpecialKeyPath:)
                                      withArguments:UIButtonTouchUpInsideKeyPath, nil];
            
            [[viewController.button2 should] receive:@selector(handleSpecialKeyPath:)
                                       withArguments:UIButtonTouchUpInsideKeyPath, nil];
            
            [BNDBindingSpecialKeyPathsHandler handleSpecialKeyPathsForBinding:binding];
        });
    });
});

SPEC_END
