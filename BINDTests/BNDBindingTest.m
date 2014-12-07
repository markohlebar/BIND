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
#import "BNDBindingTypes.h"

@interface BNDBindingTest : XCTestCase {
	Car *_car;
	Engine *_engine;
    ParkingTicket *_ticket;
	BNDBinding *_binding;
}
@end

@implementation BNDBindingTest

- (void)setUp {
	[super setUp];

    _engine = Engine.new;
    _ticket = ParkingTicket.new;
	_car = Car.new;
    _car.engine = _engine;

	_binding = BNDBinding.new;
}

- (void)tearDown {
	[super tearDown];

	_binding = nil;
	_car = nil;
    _ticket = nil;
	_engine = nil;
}

- (void)testBINDInitialValueLeftToRightAssignment {
	_car.make = @"Toyota";
	_ticket.carMake = nil;

	_binding.BIND = @"make -> carMake";
	[_binding bindLeft:_car
	         withRight:_ticket];

	XCTAssertTrue([_ticket.carMake isEqual:@"Toyota"], @"Car make on the ticket should be Toyota");
}

- (void)testBINDInitialValueRightToLeftAssignment {
    _car.make = @"Toyota";
    _ticket.carMake = nil;
    
    _binding.BIND = @"carMake <- make";
    [_binding bindLeft:_ticket
             withRight:_car];
    
    XCTAssertTrue([_ticket.carMake isEqual:@"Toyota"], @"Car make on the ticket should be Toyota");
}

- (void)testBINDInitialValueBidirectionalAssignment {
    _car.make = @"Toyota";
    _ticket.carMake = nil;
    
    _binding.BIND = @"make <> carMake";
    [_binding bindLeft:_car
             withRight:_ticket];
    
    XCTAssertTrue([_ticket.carMake isEqual:@"Toyota"], @"Car make on the ticket should be Toyota");
}

- (void)testBINDInitialValueLeftToRightNoAssignment {
    _car.make = @"Toyota";
    _ticket.carMake = nil;
    
    _binding.BIND = @"make !-> carMake";
    [_binding bindLeft:_car
             withRight:_ticket];
    
    XCTAssertNil(_ticket.carMake, @"Car make on the ticket should be nil");
}

- (void)testBINDInitialValueRightToLeftNoAssignment {
    _car.make = @"Toyota";
    _ticket.carMake = nil;
    
    _binding.BIND = @"carMake <-! make";
    [_binding bindLeft:_ticket
             withRight:_car];
    
    XCTAssertNil(_ticket.carMake, @"Car make on the ticket should be nil");
}

- (void)testBINDInitialValueBidirectionalNoAssignment {
    _car.make = @"Toyota";
    _ticket.carMake = nil;
    
    _binding.BIND = @"make <!> carMake";
    [_binding bindLeft:_car
             withRight:_ticket];
    
    XCTAssertNil(_ticket.carMake, @"Car make on the ticket should be nil");
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
	_binding.BIND = @"rpm <- speed | !RPMToSpeedTransformer";
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

- (void)testBINDLeftToRightNoInitialisationBindingUpdates {
    _car.speed = 100;
    _engine.rpm = 10000;
    _binding.BIND = @"rpm !-> speed | RPMToSpeedTransformer";
    [_binding bindLeft:_engine
             withRight:_car];
    
    _engine.rpm = 20000;
    XCTAssertTrue(_car.speed == 200, @"speed of the car should be 200");
    
    _car.speed = 300;
    XCTAssertTrue(_engine.rpm == 20000, @"engine rpm should remain 20000");
}

- (void)testBINDRightToLeftNoInitialisationBindingUpdates {
    _car.speed = 100;
    _engine.rpm = 10000;
    _binding.BIND = @"rpm <-! speed | !RPMToSpeedTransformer";
    [_binding bindLeft:_engine
             withRight:_car];
    
    _car.speed = 200;
    XCTAssertTrue(_engine.rpm == 20000, @"rpm of the engine should be 20000");
    
    _engine.rpm = 10000;
    XCTAssertTrue(_car.speed == 200, @"car speed should remain 200");
}

- (void)testBINDBiDirectionalNoInitialisationUpdates {
    _car.speed = 100;
    _engine.rpm = 10000;
    _binding.BIND = @"rpm <!> speed | RPMToSpeedTransformer";
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
	_binding.BIND = @"rpm -> speed | RPMToSpeedTransformer";

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
}

- (void)testBINDTransformDirectionAssignsCorrectly {
	_engine.rpm = 10000;

	_binding.BIND = @"speed <- rpm | RPMToSpeedTransformer";
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

- (void)testBindingSameObjectUpdatesCorrectValue {
    _car.speed = 100;
    _car.engine = [Engine new];
    
    _binding.BIND = @"speed !-> engine.rpm | !RPMToSpeedTransformer";
    [_binding bindLeft:_car withRight:_car];
    
    _car.speed = 200;
    XCTAssertTrue(_car.engine.rpm == 20000, @"should update the correct value if binding the same object");
}

- (void)testBINDPerformance {
	__block Engine *engine = [Engine new];
	__block Car *car = [Car new];
	[self measureBlock: ^{
	    _binding.BIND = @"rpm->speed|RPMToSpeedTransformer";
	    [_binding bindLeft:engine
	             withRight:car];
	    [_binding unbind];
	}];
}

#pragma mark - Crash tests

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

- (void)testBindDoesntCrashWhenOneObjectReferenceIsLost {
    _binding.BIND = @"rpm <> speed";
    [_binding bindLeft:_engine withRight:_car];
    
    _car = nil;
    
    XCTAssertNoThrow([_engine setRpm:10000], @"Should not throw an exception on updating values on unbound objects");
}

@end
