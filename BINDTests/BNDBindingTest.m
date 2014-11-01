//
//  BNDBindingTest.m
//  BIND
//
//  Created by Marko Hlebar on 30/10/2014.
//  Copyright (c) 2014 Marko Hlebar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "BNDBinding.h"
#import "BNDTestObjects.h"

@interface BNDBindingTest : XCTestCase {
    Car *_car;
    Engine *_engine;
    BNDBinding *_binding;
}
@end

@implementation BNDBindingTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    _car = Car.new;
    _engine = Engine.new;
    _binding = BNDBinding.new;
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    
    _binding = nil;
    _car = nil;
    _engine = nil;
}

- (void)testBINDKeyPathAssignment {
    _binding.BIND = @"keyPath1->keyPath2";
    XCTAssertEqualObjects(_binding.leftKeyPath, @"keyPath1", @"keypath should be keyPath1");
    XCTAssertEqualObjects(_binding.rightKeyPath, @"keyPath2", @"keypath should be keyPath2");
    XCTAssertTrue(_binding.initialAssignment == BNDBindingInitialAssignmentLeftToRight, @"assignment should be right");
    
    _binding.BIND = @"keyPath1 -> keyPath2";
    XCTAssertEqualObjects(_binding.leftKeyPath, @"keyPath1", @"keypath should be keyPath1");
    XCTAssertEqualObjects(_binding.rightKeyPath, @"keyPath2", @"keypath should be keyPath2");
    XCTAssertTrue(_binding.initialAssignment == BNDBindingInitialAssignmentLeftToRight, @"assignment should be right");
    
    _binding.BIND = @"keyPath1     ->     keyPath2";
    XCTAssertEqualObjects(_binding.leftKeyPath, @"keyPath1", @"keypath should be keyPath1");
    XCTAssertEqualObjects(_binding.rightKeyPath, @"keyPath2", @"keypath should be keyPath2");
    XCTAssertTrue(_binding.initialAssignment == BNDBindingInitialAssignmentLeftToRight, @"assignment should be right");
    
    _binding.BIND = @"keyPath1<-keyPath2";
    XCTAssertEqualObjects(_binding.leftKeyPath, @"keyPath1", @"keypath should be keyPath1");
    XCTAssertEqualObjects(_binding.rightKeyPath, @"keyPath2", @"keypath should be keyPath2");
    XCTAssertTrue(_binding.initialAssignment == BNDBindingInitialAssignmentRightToLeft, @"assignment should be left");
    
    _binding.BIND = @"keyPath1<>keyPath2";
    XCTAssertEqualObjects(_binding.leftKeyPath, @"keyPath1", @"keypath should be keyPath1");
    XCTAssertEqualObjects(_binding.rightKeyPath, @"keyPath2", @"keypath should be keyPath2");
    XCTAssertTrue(_binding.initialAssignment == BNDBindingInitialAssignmentNone, @"assignment should be none");
}

- (void)testBINDTransformers {
    _binding.BIND = @"keyPath1->keyPath2|RPMToSpeedTransformer";
    XCTAssertNotNil(_binding.valueTransformer, @"value transformer should not be nil");
    XCTAssertTrue([_binding.valueTransformer isKindOfClass:RPMToSpeedTransformer.class], @"transformer should be FloatTransformer");
}

- (void)testBINDErroneousInput {
    XCTAssertThrows([_binding setBIND:@"keyPath1-keyPath2"], @"should assert for no assignment symbol");
    XCTAssertThrows([_binding setBIND:@"keyPath1->"], @"should assert for no keypaths");
    XCTAssertThrows([_binding setBIND:@"->keyPath2"], @"should assert for no keypaths");
    XCTAssertThrows([_binding setBIND:@"keyPath->keyPath2|FooBar"], @"should assert for invalid transformer");
}

- (void)testBINDInitialValueLeftAssignment {
    _car.speed = 0;
    _engine.rpm = 10000;
    
    _binding.BIND = @"rpm -> speed | RPMToSpeedTransformer";
    [_binding bindLeft:_engine
            withRight:_car];
    
    XCTAssertTrue(_car.speed == 100, @"speed of the _car should be rpm / 100");
}

- (void)testBINDInitialValueRightAssignment {
    _car.speed = 100;
    _engine.rpm = 0;
    _binding.BIND = @"rpm <- speed | RPMToSpeedTransformer";
    [_binding bindLeft:_engine
            withRight:_car];
    
    XCTAssertTrue(_engine.rpm == 10000, @"rpm of the _engine should be speed * 100");
}

- (void)testBINDInitialValueNoAssignment {
    _car.speed = 100;
    _engine.rpm = 999;
    _binding.BIND = @"speed <> rpm | RPMToSpeedTransformer";
    [_binding bindLeft:_car
            withRight:_engine];
    
    XCTAssertTrue(_car.speed == 100, @"speed of the _car should remain 100");
    XCTAssertTrue(_engine.rpm == 999, @"rpm of the _engine should remain 999");
}

- (void)testBINDOtherObjectUpdatesReflectOnObject {
    _car.speed = 100;
    _engine.rpm = 10000;
    _binding.BIND = @"rpm -> speed | RPMToSpeedTransformer";
    [_binding bindLeft:_engine
            withRight:_car];
    
    _engine.rpm = 20000;
    XCTAssertTrue(_car.speed == 200, @"speed of the _car should be 200");
}

- (void)testBINDObjectUpdatesReflectOnOtherObject {
    _car.speed = 100;
    _engine.rpm = 10000;
    _binding.BIND = @"rpm -> speed | RPMToSpeedTransformer";
    [_binding bindLeft:_engine
            withRight:_car];
    
    _car.speed = 200;
    XCTAssertTrue(_engine.rpm == 20000, @"_engine rpm should be 20000");
}

- (void)testBINDBindingObjectsBeforeBINDingAssignsValues {
    _car.speed = 0;
    _engine.rpm = 10000;
    [_binding bindLeft:_engine
            withRight:_car];
    _binding.BIND = @"rpm -> speed| RPMToSpeedTransformer";

    XCTAssertTrue(_car.speed == 100, @"_car speed should be 100");
}

- (void)testBINDBindingNewObjectsAssignsValues {
    _car.speed = 0;
    _engine.rpm = 10000;
    _binding.BIND = @"rpm -> speed | RPMToSpeedTransformer";
    [_binding bindLeft:_engine
            withRight:_car];
    
    _car = Car.new;
    _car.speed = 0;
    
    _engine = Engine.new;
    _engine.rpm = 20000;
    
    [_binding bindLeft:_engine
            withRight:_car];
    
    XCTAssertTrue(_car.speed == 200, @"_car speed should be 200");
    XCTAssertEqual(_engine, _binding.leftObject, @"_car should be new object");
    XCTAssertEqual(_car, _binding.rightObject, @"_engine should be new other object");
}

- (void)testBINDTransformDirectionModifierIsAssigned {
    _binding.BIND = @"rpm -> speed | RPMToSpeedTransformer";
    XCTAssertTrue(_binding.transformDirection == BNDBindingTransformDirectionLeftToRight, @"Unmodified transform direction should be left to right.");
    
    _binding.BIND = @"rpm -> speed | !RPMToSpeedTransformer";
    XCTAssertTrue(_binding.transformDirection == BNDBindingTransformDirectionRightToLeft, @"Modified transform direction should be right to left.");
}

- (void)testBINDTransformDirectionAssignsCorrectly {
    _engine.rpm = 10000;
    
    _binding.BIND = @"speed <- rpm | !RPMToSpeedTransformer";
    [_binding bindLeft:_car
             withRight:_engine];
    
    XCTAssertTrue(_car.speed == 100, @"_car speed should be 100");
}

- (void)testUnbindRemovesReferences {
    [_binding bindLeft:_engine withRight:_car];
    [_binding unbind];
    
    XCTAssertNil(_binding.leftObject);
    XCTAssertNil(_binding.rightObject);
}

- (void)testUnbindDoesntCrashWhenObjectsAreNotSet {
    _binding.BIND = @"rpm -> speed";
    XCTAssertNoThrow([_binding unbind], @"Should not throw an exception when unbinding and no objects");
}

- (void)testUnbindDoesntCrashWhenKeyPathsAreNotSet {
    [_binding bindLeft:_engine withRight:_car];
    XCTAssertNoThrow([_binding unbind], @"Should not throw an exception when unbinding and no keypaths");
}

- (void)testUnbindingDoesntCrashWhenCalledTwice {
    _binding.BIND = @"rpm -> speed";
    [_binding bindLeft:_engine withRight:_car];
    [_binding unbind];
    
    XCTAssertNoThrow([_binding unbind], @"Should not throw an exception on consecutive unbind calls");
}

- (void)testBINDPerformance {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
        _binding.BIND = @"keyPath1->keyPath2|RPMToSpeedTransformer";
    }];
}

@end
