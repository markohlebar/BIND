//
//  BNDMacrosTest.m
//  BIND
//
//  Created by Marko Hlebar on 08/03/2015.
//  Copyright (c) 2015 Marko Hlebar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "BNDMacros.h"
#import "BNDBinding.h"
#import "BNDTestObjects.h"
#import "UIButton+BNDBinding.h"

@interface BNDMacrosTest : XCTestCase

@end

@implementation BNDMacrosTest {
    BNDBinding *_binding;
    Engine *_engine;
    Car *_car;
}

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    _engine = [Engine new];
    _car = [Car new];
    _car.engine = _engine;
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    
    _engine = nil;
    _car = nil;
    _binding = nil;
}

- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

#pragma mark - Keypath Checking Shorthand Syntax

- (void)testBINDKeyPathChecking {
    _binding = BIND(_engine,rpm,->,_car,speed);
    XCTAssertEqualObjects(_binding.BIND, @"rpm->speed", @"BIND should produce the same output");
    XCTAssertEqual(_engine, _binding.leftObject, @"BIND should bind the left object");
    XCTAssertEqual(_car, _binding.rightObject, @"BIND should bind the right object");
}

- (void)testBINDKeyPathTransform {
    _binding = BINDT(_engine,rpm,->,_car,speed, RPMToSpeedTransformer);
    XCTAssertEqualObjects(_binding.BIND, @"rpm->speed|RPMToSpeedTransformer", @"BIND should produce the same output");
    XCTAssertEqual(_engine, _binding.leftObject, @"BIND should bind the left object");
    XCTAssertEqual(_car, _binding.rightObject, @"BIND should bind the right object");
}

- (void)testBINDKeyPathTransformDirection {
    _binding = BINDRT(_engine,rpm,->,_car,speed,RPMToSpeedTransformer);
    XCTAssertEqualObjects(_binding.BIND, @"rpm->speed|!RPMToSpeedTransformer", @"BIND should produce the same output");
    XCTAssertEqual(_engine, _binding.leftObject, @"BIND should bind the left object");
    XCTAssertEqual(_car, _binding.rightObject, @"BIND should bind the right object");
}

- (void)testBINDKeyPathNilObjects {
    _engine = nil;
    _car = nil;
    
    _binding = BINDRT(_engine,rpm,->,_car,speed,RPMToSpeedTransformer);
    XCTAssertEqualObjects(_binding.BIND, @"rpm->speed|!RPMToSpeedTransformer", @"BIND should produce the same output");
    XCTAssertNil(_binding.leftObject, @"Left should be nil");
    XCTAssertNil(_binding.rightObject, @"Right should be nil");
}

#pragma mark - Shorthand keypaths

- (void)testBINDShorthandAssignsCorrectValues {
    UITextField *textField = [UITextField new];
    UILabel *label = [UILabel new];
    
    BINDS(textField, ->, label);
    textField.text = @"Kim";
    
    XCTAssertEqualObjects(textField.text, label.text, @"The objects should have equal text values");
}

- (void)testBINDShorthandRightAssignsCorrectValues {
    UILabel *label = [UILabel new];
    
    BINDSR(_car, make, ->, label);
    _car.make = @"Toyota";
    
    XCTAssertEqualObjects(_car.make, label.text, @"The objects should have equal values");
}

- (void)testBINDShorthandLeftAssignsCorrectValues {
    UITextField *textField = [UITextField new];
    
    BINDSL(textField, ->, _car, make);
    textField.text = @"Toyota";
    
    XCTAssertEqualObjects(_car.make, textField.text, @"The objects should have equal values");
}

- (void)testBINDTargetActionTriggersActionBlock {
    UITextField *textField = [UITextField new];
    
    __block id receivedSender = nil;
    __block id receivedValue = nil;

    [BINDO(textField, text) observe:^(id sender, id value) {
        receivedSender = sender;
        receivedValue = value;
    }];
          
    textField.text = @"Kim";
    XCTAssertEqual(textField, receivedSender, @"Sender should be the textfield");
    XCTAssertEqualObjects(textField.text, receivedValue, @"Observed value should be the same");
}

- (void)testBINDObserveUIButtonSpecialKeyPath {
    UIButton *button = [UIButton new];
    
    __block id receivedSender = nil;
    __block id receivedValue = nil;
    
    [BINDO(button, onTouchUpInside) observe:^(id sender, id value) {
        receivedSender = sender;
        receivedValue = value;
    }];
    
    button.onTouchUpInside = button;
    XCTAssertEqual(button, receivedSender, @"Button should be the observable");
    XCTAssertEqualObjects(button, receivedValue, @"Button should be the value passed back");
}

- (void)testBINDObserveShorthandUIButtonSpecialKeyPath {
    UIButton *button = [UIButton new];
    
    __block id receivedSender = nil;
    __block id receivedValue = nil;
    
    [BINDOS(button) observe:^(id sender, id value) {
        receivedSender = sender;
        receivedValue = value;
    }];
    
    button.onTouchUpInside = button;
    XCTAssertEqual(button, receivedSender, @"Button should be the observable");
    XCTAssertEqualObjects(button, receivedValue, @"Button should be the value passed back");
}

- (void)testRegisterShorthands {
    bndRegisterShorthands(@{
                            @"Engine" : @"rpm",
                            @"Car" : @"speed"
                            });
    XCTAssertNoThrow(BINDS(_car, ->, _engine), @"The shorthand keypaths should be registered");
}

- (void)testBINDCommand {
    Command *command = [Command new];
    UIButton *button = [UIButton new];

    BINDCommand(button, onTouchUpInside, command);
    
    button.onTouchUpInside = button;
    XCTAssertTrue(command.isExecuted, @"Command should execute on touch up inside");
}

@end
