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

@interface BNDBindingTest : XCTestCase

@end

@implementation BNDBindingTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

- (void)testBINDKeyPathAssignment {
    BNDBinding *binding = [BNDBinding new];
    binding.BIND = @"keyPath1->keyPath2";
    XCTAssertEqualObjects(binding.keyPath, @"keyPath1", @"keypath should be keyPath1");
    XCTAssertEqualObjects(binding.otherKeyPath, @"keyPath2", @"keypath should be keyPath2");
    XCTAssertTrue(binding.initialAssignment == BNDBindingInitialAssignmentRight, @"assignment should be right");
    
    binding.BIND = @"keyPath1 -> keyPath2";
    XCTAssertEqualObjects(binding.keyPath, @"keyPath1", @"keypath should be keyPath1");
    XCTAssertEqualObjects(binding.otherKeyPath, @"keyPath2", @"keypath should be keyPath2");
    XCTAssertTrue(binding.initialAssignment == BNDBindingInitialAssignmentRight, @"assignment should be right");
    
    binding.BIND = @"keyPath1     ->     keyPath2";
    XCTAssertEqualObjects(binding.keyPath, @"keyPath1", @"keypath should be keyPath1");
    XCTAssertEqualObjects(binding.otherKeyPath, @"keyPath2", @"keypath should be keyPath2");
    XCTAssertTrue(binding.initialAssignment == BNDBindingInitialAssignmentRight, @"assignment should be right");
    
    binding.BIND = @"keyPath1<-keyPath2";
    XCTAssertEqualObjects(binding.keyPath, @"keyPath1", @"keypath should be keyPath1");
    XCTAssertEqualObjects(binding.otherKeyPath, @"keyPath2", @"keypath should be keyPath2");
    XCTAssertTrue(binding.initialAssignment == BNDBindingInitialAssignmentLeft, @"assignment should be left");
    
    binding.BIND = @"keyPath1<>keyPath2";
    XCTAssertEqualObjects(binding.keyPath, @"keyPath1", @"keypath should be keyPath1");
    XCTAssertEqualObjects(binding.otherKeyPath, @"keyPath2", @"keypath should be keyPath2");
    XCTAssertTrue(binding.initialAssignment == BNDBindingInitialAssignmentNone, @"assignment should be none");
}

- (void)testBINDTransformers {
    BNDBinding *binding = [BNDBinding new];
    binding.BIND = @"keyPath1->keyPath2|RPMToSpeedTransformer";
    XCTAssertNotNil(binding.valueTransformer, @"value transformer should not be nil");
    XCTAssertTrue([binding.valueTransformer isKindOfClass:RPMToSpeedTransformer.class], @"transformer should be FloatTransformer");
}

- (void)testBINDErroneousInput {
    BNDBinding *binding = [BNDBinding new];
    XCTAssertThrows([binding setBIND:@"keyPath1-keyPath2"], @"should assert for no assignment symbol");
    XCTAssertThrows([binding setBIND:@"keyPath1->"], @"should assert for no keypaths");
    XCTAssertThrows([binding setBIND:@"->keyPath2"], @"should assert for no keypaths");
    XCTAssertThrows([binding setBIND:@"keyPath->keyPath2|FooBar"], @"should assert for invalid transformer");
}

- (void)testBINDInitialValueLeftAssignment {
    Car *car = Car.new;
    car.speed = 0;
    
    Engine *engine = Engine.new;
    engine.rpm = 10000;
    
    BNDBinding *binding = [BNDBinding new];
    binding.BIND = @"speed <- rpm | RPMToSpeedTransformer";
    [binding bindObject:car
            otherObject:engine];
    
    XCTAssertTrue(car.speed == 100, @"speed of the car should be rpm / 100");
}

- (void)testBINDInitialValueRightAssignment {
    Car *car = Car.new;
    car.speed = 100;
    
    Engine *engine = Engine.new;
    engine.rpm = 0;
    
    BNDBinding *binding = [BNDBinding new];
    binding.BIND = @"speed -> rpm | RPMToSpeedTransformer";
    [binding bindObject:car
            otherObject:engine];
    
    XCTAssertTrue(engine.rpm == 10000, @"rpm of the engine should be speed * 100");
}

- (void)testBINDInitialValueNoAssignment {
    Car *car = Car.new;
    car.speed = 100;
    
    Engine *engine = Engine.new;
    engine.rpm = 999;
    
    BNDBinding *binding = [BNDBinding new];
    binding.BIND = @"speed <> rpm | RPMToSpeedTransformer";
    [binding bindObject:car
            otherObject:engine];
    
    XCTAssertTrue(car.speed == 100, @"speed of the car should remain 100");
    XCTAssertTrue(engine.rpm == 999, @"rpm of the engine should remain 999");
}

- (void)testBINDOtherObjectUpdatesReflectOnObject {
    Car *car = Car.new;
    car.speed = 100;
    
    Engine *engine = Engine.new;
    engine.rpm = 10000;
    
    BNDBinding *binding = [BNDBinding new];
    binding.BIND = @"speed <- rpm | RPMToSpeedTransformer";
    [binding bindObject:car
            otherObject:engine];
    
    engine.rpm = 20000;
    XCTAssertTrue(car.speed == 200, @"speed of the car should be 200");
}

- (void)testBINDObjectUpdatesReflectOnOtherObject {
    Car *car = Car.new;
    car.speed = 100;
    
    Engine *engine = Engine.new;
    engine.rpm = 10000;
    
    BNDBinding *binding = [BNDBinding new];
    binding.BIND = @"speed <- rpm | RPMToSpeedTransformer";
    [binding bindObject:car
            otherObject:engine];
    
    car.speed = 200;
    XCTAssertTrue(engine.rpm == 20000, @"engine rpm should be 20000");
}

- (void)testBINDBindingObjectsBeforeBINDingAssignsValues {
    Car *car = Car.new;
    car.speed = 0;
    
    Engine *engine = Engine.new;
    engine.rpm = 10000;
    
    BNDBinding *binding = [BNDBinding new];
    [binding bindObject:car
            otherObject:engine];
    binding.BIND = @"speed <- rpm | RPMToSpeedTransformer";

    XCTAssertTrue(car.speed == 100, @"car speed should be 100");
}

- (void)testBINDBindingNewObjectsAssignsValues {
    Car *car = Car.new;
    car.speed = 0;
    
    Engine *engine = Engine.new;
    engine.rpm = 10000;
    
    BNDBinding *binding = [BNDBinding new];
    binding.BIND = @"speed <- rpm | RPMToSpeedTransformer";
    [binding bindObject:car
            otherObject:engine];
    
    car = Car.new;
    car.speed = 0;
    
    engine = Engine.new;
    engine.rpm = 20000;
    
    [binding bindObject:car
            otherObject:engine];
    
    XCTAssertTrue(car.speed == 200, @"car speed should be 200");
    XCTAssertEqual(car, binding.object, @"car should be new object");
    XCTAssertEqual(engine, binding.otherObject, @"engine should be new other object");
}

- (void)testBINDPerformance {
    BNDBinding *binding = [BNDBinding new];
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
        binding.BIND = @"keyPath1->keyPath2|RPMToSpeedTransformer";
    }];
}

@end
