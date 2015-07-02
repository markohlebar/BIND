//
//  BNDBindingTest.m
//  BIND
//
//  Created by Marko Hlebar on 30/10/2014.
//  Copyright (c) 2014 Marko Hlebar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "BNDTestObjects.h"
#import "BIND.h"

@interface BNDBindingTest : XCTestCase {
	Car *_car;
	Engine *_engine;
    ParkingTicket *_ticket;
	BNDBinding *_binding;
}

@property (nonatomic, strong) NSString *blah;
@end

@interface BNDBinding (Test)
+ (NSMutableSet *)allBindings;
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

#pragma mark - Memory management

//- (void)testAAUnassignedBindingsWorkUntilObservableIsDealloced {
//    BIND(_car, speed, ~>, _engine, rpm);
//    XCTAssertTrue([BNDBinding allBindings].count == 1, @"Number of bindings should be 1");
//    
//    _car = nil;
//    XCTAssertTrue([BNDBinding allBindings].count == 0, @"Number of bindings should be 0");
//}
//
//- (void)testZZUnassignedBindingsWorkUntilObservableIsDealloced {
//    BIND(_engine, rpm, ~>, _car, speed);
//    XCTAssertTrue([BNDBinding allBindings].count == 1, @"Number of bindings should be 1");
//    
//    _engine = nil;
//    _car.engine = nil;
//    XCTAssertTrue([BNDBinding allBindings].count == 0, @"Number of bindings should be 0");
//}

#pragma mark - Binding

- (void)testBINDInitialValueLeftToRightAssignment {
	_car.make = @"Toyota";
	_ticket.carMake = nil;

	_binding.BIND = @"make ~> carMake";
	[_binding bindLeft:_car
	         withRight:_ticket];

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
    
    _binding.BIND = @"make !~> carMake";
    [_binding bindLeft:_car
             withRight:_ticket];
    
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
	_binding.BIND = @"rpm ~> speed | RPMToSpeedTransformer";
	[_binding bindLeft:_engine
	         withRight:_car];

	_engine.rpm = 20000;
	XCTAssertTrue(_car.speed == 200, @"speed of the car should be 200");

	_car.speed = 300;
	XCTAssertTrue(_engine.rpm == 20000, @"engine rpm should remain 20000");
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
    _binding.BIND = @"rpm !~> speed | RPMToSpeedTransformer";
    [_binding bindLeft:_engine
             withRight:_car];
    
    _engine.rpm = 20000;
    XCTAssertTrue(_car.speed == 200, @"speed of the car should be 200");
    
    _car.speed = 300;
    XCTAssertTrue(_engine.rpm == 20000, @"engine rpm should remain 20000");
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
	_binding.BIND = @"rpm ~> speed | RPMToSpeedTransformer";

	XCTAssertTrue(_car.speed == 100, @"car speed should be 100");
}

- (void)testBINDBindingNewObjectsAssignsValues {
	_car.speed = 0;
	_engine.rpm = 10000;
	_binding.BIND = @"rpm ~> speed | RPMToSpeedTransformer";
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

- (void)testUnbindRemovesReferences {
	[_binding bindLeft:_engine withRight:_car];
	[_binding unbind];

	XCTAssertNil(_binding.leftObject);
	XCTAssertNil(_binding.rightObject);
}

- (void)testBindingSameObjectUpdatesCorrectValue {
    _car.speed = 100;
    _car.engine = [Engine new];
    
    _binding.BIND = @"speed !~> engine.rpm | !RPMToSpeedTransformer";
    [_binding bindLeft:_car withRight:_car];
    
    _car.speed = 200;
    XCTAssertTrue(_car.engine.rpm == 20000, @"should update the correct value if binding the same object");
}

- (void)testUpdatingTheParentTriggersObservation {
    _car.engine.rpm = 100;

    __block CGFloat rpm = 0;
    [BINDO(_car, engine.rpm) observe:^(id observable, id value, NSDictionary *observationInfo) {
        rpm = _car.engine.rpm;
    }];
    
    Engine *engine = [Engine new];
    engine.rpm = 200;
    _car.engine = engine;
    
    XCTAssertTrue(rpm == 200, @"Should call update when parent object is updated");
}

#pragma mark - Async Transformer

- (void)expectAsyncValueTransform:(void(^)(void)) expectationBlock {
    [self expectAsyncValueTransform:expectationBlock afterTime:0.2];
}

- (void)expectAsyncValueTransform:(void(^)(void)) expectationBlock
                        afterTime:(NSTimeInterval) time {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Expect async transform"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        expectationBlock();
        [expectation fulfill];
    });
    [self waitForExpectationsWithTimeout:time + 0.1 handler:nil];
}

- (void)testAsyncTransformersSetInitialValueWithForwardTransform {
    Engine *engine = [Engine new];
    engine.rpm = 10000;
    
    __block Car *car = [Car new];
    _binding.BIND = @"rpm ~> speed | AsyncRPMToSpeedTransformer";
    [_binding bindLeft:engine withRight:car];
    
    [self expectAsyncValueTransform:^{
        XCTAssertTrue(car.speed == 100, "Should be able to update the value asynchronously");
    }];
}

- (void)testAssignsLeftToRightValueAsynchronously {
    Engine *engine = [Engine new];
    engine.rpm = 10000;
    
    __block Car *car = [Car new];
    _binding.BIND = @"rpm ~> speed | AsyncRPMToSpeedTransformer";
    [_binding bindLeft:engine withRight:car];
        
    engine.rpm = 20000;
    
    [self expectAsyncValueTransform:^{
        XCTAssertTrue(car.speed == 200, "Should be able to update the value asynchronously");
    }];
}

- (void)testAssignsBidirectionalValueAsynchronouslyThrowsException {
    XCTAssertThrows(_binding.BIND = @"rpm <> speed | AsyncRPMToSpeedTransformer", @"Bidirectional asynchronous binding not supported");
}

#pragma mark - Performance

- (void)testBINDPerformance {    
	__block Engine *engine = [Engine new];
	__block Car *car = [Car new];
	[self measureBlock: ^{
	    _binding.BIND = @"rpm~>speed|RPMToSpeedTransformer";
	    [_binding bindLeft:engine
	             withRight:car];
	    [_binding unbind];
	}];
}

- (void)testBINDAssignmentPerformance {
    __block Engine *engine = [Engine new];
    __block Car *car = [Car new];
    _binding.BIND = @"rpm~>speed|RPMToSpeedTransformer";
    [_binding bindLeft:engine
             withRight:car];
    [self measureBlock: ^{
        engine.rpm = 10000;
    }];
}

#pragma mark - Action Transform

- (void)testTransformBlockIsCalledWhenValueChanges {
    _binding = [BIND(_engine,rpm,~>,_car,speed) transform:^id(id object, id value) {
        return @([value integerValue] / 100);;
    }];
        
    _engine.rpm = 10000;
    XCTAssertTrue(_car.speed == 100, @"Car speed should reflect the transform");
}

- (void)testCallingTransformChangesTheValues {
    _binding = BIND(_car, speed, ~>, _engine, rpm);
    _car.speed = 100;
    XCTAssertTrue(_engine.rpm == 100, @"Engine rpm should be equal car speed at this point");
    
    [_binding transform:^id(id object, id value) {
        return @([value integerValue] * 100);
    }];
    XCTAssertTrue(_engine.rpm == 10000, @"Engine rpm should reflect the transform");
}

- (void)testTransformBlockIsCalledWhenValueChangesAndTransformerIsAssigned {
    _binding = [BINDT(_engine,rpm,~>,_car,speed, RPMToSpeedTransformer) transform:^id(id object, id value) {
        return @([value integerValue] / 2);
    }];
    _engine.rpm = 10000;
    XCTAssertTrue(_car.speed == 50, @"Car speed should reflect transformer change + transform block change");
}

- (void)testPassesTheCorrectTransformedObjectRight {
    __block id transformedObject = nil;
    _binding = [BIND(_car, speed, ~>, _engine, rpm)
                transform:^id(id object, id value) {
                    transformedObject = object;
                    return value;
    }];

    _car.speed = 100;
    XCTAssertEqual(transformedObject, _car, @"Car should be the transformed object");
    transformedObject = nil;
}

- (void)testPassesTheCorrectTransformedObjectBidirectional {
    __block id transformedObject = nil;
    _binding = [BIND(_car, speed, <>, _engine, rpm)
                transform:^id(id object, id value) {
                    transformedObject = object;
                    return value;
                }];
    
    _engine.rpm = 10000;
    XCTAssertEqual(transformedObject, _engine, @"Engine should be the transformed object");
    
    _car.speed = 100;
    XCTAssertEqual(transformedObject, _car, @"Car should be the transformed object");
    transformedObject = nil;
}

#pragma mark - Action Observe

- (void)testObserveGetsFiredWhenDirectionIsRight {
    __block id receivedSender = nil;
    __block id receivedValue = nil;

    [BIND(_engine,rpm,~>,_car,speed) observe:^(id observable, id value, NSDictionary *observationInfo) {
        receivedSender = observable;
        receivedValue = value;
    }];
    
    _engine.rpm = 100;
    XCTAssertEqual(_engine, receivedSender, @"Received observable should be the engine");
    XCTAssertEqualObjects(@(100), receivedValue, @"Received value should be 100");

    receivedSender = nil;
}

- (void)testObserveGetsFiredWhenDirectionIsBidirectional {
    __block id receivedSender = nil;
    __block id receivedValue = nil;
    
    [BIND(_engine,rpm,<>,_car,speed) observe:^(id observable, id value, NSDictionary *observationInfo) {
        receivedSender = observable;
        receivedValue = value;
    }];
    
    _engine.rpm = 100;
    XCTAssertEqual(_engine, receivedSender, @"Received observable should be the engine");
    XCTAssertEqualObjects(@(100), receivedValue, @"Received value should be 100");
    
    _car.speed = 200;
    XCTAssertEqual(_car, receivedSender, @"Received observable should be the car");
    XCTAssertEqualObjects(@(200), receivedValue, @"Received value should be 200");
    
    receivedSender = nil;
}

- (void)testObservationInfo {
    __block NSDictionary *receivedObservationInfo = nil;
    
    [BIND(_engine,rpm,~>,_car,speed) observe:^(id observable, id value, NSDictionary *observationInfo) {
        receivedObservationInfo = observationInfo;
    }];
    
    _engine.rpm = 100;
    XCTAssertNotNil(receivedObservationInfo, @"Should contain observation info.");
}

#pragma mark - Crash tests

- (void)testUnbindDoesntCrashWhenObjectsAreNotSet {
    _binding.BIND = @"rpm ~> speed";
    XCTAssertNoThrow([_binding unbind], @"Should not throw an exception when unbinding and no objects");
}

- (void)testUnbindDoesntCrashWhenKeyPathsAreNotSet {
    [_binding bindLeft:_engine withRight:_car];
    XCTAssertNoThrow([_binding unbind], @"Should not throw an exception when unbinding and no keypaths");
}

- (void)testUnbindingDoesntCrashWhenCalledTwice {
    _binding.BIND = @"rpm ~> speed";
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
