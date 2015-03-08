//
//  BNDFunctions.m
//  BIND
//
//  Created by Marko Hlebar on 07/03/2015.
//  Copyright (c) 2015 Marko Hlebar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "BNDFunctions.h"
#import "BNDTestObjects.h"

@interface BNDFunctions : XCTestCase

@end

@implementation BNDFunctions {
    Engine *_engine;
    Car *_car;
}

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    _car = [Car new];
    _engine = [Engine new];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    
    _car = nil;
    _engine = nil;
}

- (void)testDecmoposesOneLevelKeypaths {
    id decomposedObject = nil;
    SEL decomposedSetter = nil;
    bndDecomposeKeyPath(_car, @"speed", &decomposedObject, &decomposedSetter);
    
    XCTAssertEqual(decomposedObject, _car, @"Decomposed object should be the car");
    XCTAssertEqualObjects(NSStringFromSelector(decomposedSetter), @"setSpeed:", @"Decomposed setter should be setSpeed:");
}

- (void)testDecmoposesTwoLevelKeypaths {
    id decomposedObject = nil;
    SEL decomposedSetter = nil;
    bndDecomposeKeyPath(_car, @"engine.rpm", &decomposedObject, &decomposedSetter);
    
    XCTAssertEqual(decomposedObject, _car.engine, @"Decomposed object should be the engine");
    XCTAssertEqualObjects(NSStringFromSelector(decomposedSetter), @"setRpm:", @"Decomposed setter should be setRpm:");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
