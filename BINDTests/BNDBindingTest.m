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
    
    _car = Car.new;
    _engine = Engine.new;
    _binding = BNDBinding.new;
}

- (void)tearDown {
    [super tearDown];
    
    _binding = nil;
    _car = nil;
    _engine = nil;
}

- (void)testBINDKeyPathAssignment {
    _binding.BIND = @"keyPath1->keyPath2";
    XCTAssertEqualObjects(_binding.leftKeyPath, @"keyPath1", @"keypath should be keyPath1");
    XCTAssertEqualObjects(_binding.rightKeyPath, @"keyPath2", @"keypath should be keyPath2");
    XCTAssertTrue(_binding.direction == BNDBindingDirectionLeftToRight, @"assignment should be right");
    
    _binding.BIND = @"keyPath1 -> keyPath2";
    XCTAssertEqualObjects(_binding.leftKeyPath, @"keyPath1", @"keypath should be keyPath1");
    XCTAssertEqualObjects(_binding.rightKeyPath, @"keyPath2", @"keypath should be keyPath2");
    XCTAssertTrue(_binding.direction == BNDBindingDirectionLeftToRight, @"assignment should be right");
    
    _binding.BIND = @"keyPath1     ->     keyPath2";
    XCTAssertEqualObjects(_binding.leftKeyPath, @"keyPath1", @"keypath should be keyPath1");
    XCTAssertEqualObjects(_binding.rightKeyPath, @"keyPath2", @"keypath should be keyPath2");
    XCTAssertTrue(_binding.direction == BNDBindingDirectionLeftToRight, @"assignment should be right");
    
    _binding.BIND = @"keyPath1<-keyPath2";
    XCTAssertEqualObjects(_binding.leftKeyPath, @"keyPath1", @"keypath should be keyPath1");
    XCTAssertEqualObjects(_binding.rightKeyPath, @"keyPath2", @"keypath should be keyPath2");
    XCTAssertTrue(_binding.direction == BNDBindingDirectionRightToLeft, @"assignment should be left");
    
    _binding.BIND = @"keyPath1<>keyPath2";
    XCTAssertEqualObjects(_binding.leftKeyPath, @"keyPath1", @"keypath should be keyPath1");
    XCTAssertEqualObjects(_binding.rightKeyPath, @"keyPath2", @"keypath should be keyPath2");
    XCTAssertTrue(_binding.direction == BNDBindingDirectionBoth, @"assignment should be none");
}

- (void)testBINDTransformers {
    _binding.BIND = @"keyPath1->keyPath2|RPMToSpeedTransformer";
    XCTAssertNotNil(_binding.valueTransformer, @"value transformer should not be nil");
    XCTAssertTrue([_binding.valueTransformer isKindOfClass:RPMToSpeedTransformer.class], @"transformer should be RPMToSpeedTransformer");
}

- (void)testBINDErroneousInput {
    XCTAssertThrows([_binding setBIND:@"keyPath1-keyPath2"], @"should assert for no assignment symbol");
    XCTAssertThrows([_binding setBIND:@"keyPath1->"], @"should assert for no keypaths");
    XCTAssertThrows([_binding setBIND:@"->keyPath2"], @"should assert for no keypaths");
    XCTAssertThrows([_binding setBIND:@"keyPath->keyPath2|FooBar"], @"should assert for invalid transformer");
}

- (void)testBINDInitialValueLeftToRightAssignment {
    _car.speed = 0;
    _engine.rpm = 10000;
    
    _binding.BIND = @"rpm -> speed | RPMToSpeedTransformer";
    [_binding bindLeft:_engine
            withRight:_car];
    
    XCTAssertTrue(_car.speed == 100, @"speed of the car should be 100");
}

- (void)testBINDInitialValueRightToLeftAssignment {
    _car.speed = 100;
    _engine.rpm = 0;
    _binding.BIND = @"rpm <- speed | RPMToSpeedTransformer";
    [_binding bindLeft:_engine
            withRight:_car];
    
    XCTAssertTrue(_engine.rpm == 10000, @"rpm of the engine should be 10000");
}

- (void)testBINDInitialValueBidirectionalAssignment {
    _car.speed = 0;
    _engine.rpm = 10000;
    _binding.BIND = @"rpm <> speed | RPMToSpeedTransformer";
    [_binding bindLeft:_engine
             withRight:_car];
    
    XCTAssertTrue(_car.speed == 100, @"speed of the car should be 100");
}

- (void)testBINDInitialValueNoAssignment {
    _car.speed = 100;
    _engine.rpm = 999;
    _binding.BIND = @"speed <> rpm | RPMToSpeedTransformer";
    [_binding bindLeft:_car
             withRight:_engine
      setInitialValues:NO];
    
    XCTAssertTrue(_car.speed == 100, @"speed of the car should remain 100");
    XCTAssertTrue(_engine.rpm == 999, @"rpm of the engine should remain 999");
}

- (void)testBINDLeftToRightBindingUpdates {
    _car.speed = 100;
    _engine.rpm = 10000;
    _binding.BIND = @"rpm -> speed | RPMToSpeedTransformer";
    [_binding bindLeft:_engine
             withRight:_car];
    
    _engine.rpm = 20000;
    XCTAssertTrue(_car.speed == 200, @"speed of the car should be 200");
    
    _car.speed = 300;
    XCTAssertTrue(_engine.rpm == 20000, @"engine rpm should remain 20000");
}

- (void)testBINDRightToLeftBindingUpdates {
    _car.speed = 100;
    _engine.rpm = 10000;
    _binding.BIND = @"rpm <- speed | RPMToSpeedTransformer";
    [_binding bindLeft:_engine
             withRight:_car];
    
    _car.speed = 200;
    XCTAssertTrue(_engine.rpm == 20000, @"rpm of the engine should be 20000");
    
    _engine.rpm = 10000;
    XCTAssertTrue(_car.speed == 200, @"car speed should remain 200");
}

- (void)testBINDBiDirectionalUpdates {
    _car.speed = 100;
    _engine.rpm = 10000;
    _binding.BIND = @"rpm <> speed | RPMToSpeedTransformer";
    [_binding bindLeft:_engine
             withRight:_car];
    
    _car.speed = 200;
    XCTAssertTrue(_engine.rpm == 20000, @"engine rpm should be 20000");
    
    _engine.rpm = 5000;
    XCTAssertTrue(_car.speed == 50, @"car speed should be 50");
}

- (void)testBINDBindingObjectsBeforeBINDingAssignsValues {
    _car.speed = 0;
    _engine.rpm = 10000;
    [_binding bindLeft:_engine
            withRight:_car];
    _binding.BIND = @"rpm -> speed| RPMToSpeedTransformer";

    XCTAssertTrue(_car.speed == 100, @"car speed should be 100");
}

- (void)testBINDBindingNewObjectsAssignsValues {
    _car.speed = 0;
    _engine.rpm = 10000;
    _binding.BIND = @"rpm -> speed | RPMToSpeedTransformer";
    [_binding bindLeft:_engine
             withRight:_car];
    
    Car *car2 = Car.new;
    car2.speed = 0;
    
    Engine *engine2 = Engine.new;
    engine2.rpm = 20000;
    
    [_binding bindLeft:engine2
            withRight:car2];
    
    XCTAssertTrue(car2.speed == 200, @"car2 speed should be 200");
    XCTAssertEqual(engine2, _binding.leftObject, @"engine 2 should be the new left object");
    XCTAssertEqual(car2, _binding.rightObject, @"car2 should be the new right object");
    
    //we need to unbind here because the references to car2 and engine2 are lost and we have a crash if we don't.
    _binding = nil;
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
    
    XCTAssertTrue(_car.speed == 100, @"car speed should be 100");
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
