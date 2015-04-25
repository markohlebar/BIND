//
//  NSTextField+BNDBindingSpec.m
//  BIND
//
//  Created by Marko Hlebar on 13/12/2014.
//  Copyright 2014 Marko Hlebar. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "NSTextField+BNDBinding.h"
#import "BNDBinding.h"

@interface TextObserver : NSObject <NSTextFieldDelegate>
@property (nonatomic, strong) NSString *text;
@end

@implementation TextObserver
@synthesize text = _text;
- (void)setText:(NSString *)text {
    _text = text;
}

- (NSString *)text {
    return _text;
}

- (void)controlTextDidChange:(NSNotification *)obj {

}

- (void)controlTextDidEndEditing:(NSNotification *)obj {

}

@end

@interface NSTextField (Testing)
@property (nonatomic) NSObject *forwardingDelegate;
@end

SPEC_BEGIN(NSTextField_BNDBindingSpec)

describe(@"NSTextField+BNDBinding", ^{

    __block TextObserver *_observer = nil;
    __block NSTextField *_textField = nil;
    __block BNDBinding *_binding = nil;
    
    beforeEach(^{
        _observer = [TextObserver new];
        _textField = [NSTextField new];
        _textField.delegate = _observer;

        _binding = [BNDBinding bindingWithBIND:@"text !~> text"];
        [_binding bindLeft:_textField withRight:_observer];
    });

    void (^simulateTextEntry)(NSString *) = ^(NSString *text) {
        [_textField setStringValue:text];
        
        id mockNotification = [NSNotification nullMock];
        [mockNotification stub:@selector(object) andReturn:_textField];
        [_textField controlTextDidChange:mockNotification];
    };
    
    context(@"When typing in the text field", ^{
        it(@"Should update the text property", ^{
            [[_observer should] receive:@selector(setText:) withArguments:@"Foo", nil];
            simulateTextEntry(@"Foo");
        });
        
        xit(@"Should forward delegate messages to delegate", ^{
            NSObject *forwardingDelegate = _textField.forwardingDelegate;
            [[forwardingDelegate should] receive:@selector(controlTextDidChange:)];
            [[forwardingDelegate should] receive:@selector(controlTextDidEndEditing:)];

            simulateTextEntry(@"Foo");
            [_textField controlTextDidEndEditing:nil];
        });
    });
});

SPEC_END
