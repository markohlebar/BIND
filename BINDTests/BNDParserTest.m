//
//  BNDParserTest.m
//  BIND
//
//  Created by Marko Hlebar on 22/11/2014.
//  Copyright (c) 2014 Marko Hlebar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "BNDParser.h"
#import "BNDTestObjects.h"

@interface BNDParserTest : XCTestCase

@end

@implementation BNDParserTest

- (void)testBINDKeyPathAssignment {
    BNDBindingModel *definition = [BNDParser parseBIND:@"keyPath1~>keyPath2"];
    XCTAssertEqualObjects(definition.leftKeyPath, @"keyPath1", @"keypath should be keyPath1");
    XCTAssertEqualObjects(definition.rightKeyPath, @"keyPath2", @"keypath should be keyPath2");
    XCTAssertTrue(definition.direction == BNDBindingDirectionLeftToRight, @"assignment should be right");
    XCTAssertTrue(definition.transformDirection == BNDBindingTransformDirectionLeftToRight, @"transform direction should be right");
    XCTAssertTrue(definition.shouldSetInitialValues == YES, @"should set initial values");

    definition = [BNDParser parseBIND:@"keyPath1 ~> keyPath2"];
    XCTAssertEqualObjects(definition.leftKeyPath, @"keyPath1", @"keypath should be keyPath1");
    XCTAssertEqualObjects(definition.rightKeyPath, @"keyPath2", @"keypath should be keyPath2");
    XCTAssertTrue(definition.direction == BNDBindingDirectionLeftToRight, @"assignment should be right");
    XCTAssertTrue(definition.transformDirection == BNDBindingTransformDirectionLeftToRight, @"transform direction should be right");
    XCTAssertTrue(definition.shouldSetInitialValues == YES, @"should set initial values");
    
    definition = [BNDParser parseBIND:@"keyPath1     ~>     keyPath2"];
    XCTAssertEqualObjects(definition.leftKeyPath, @"keyPath1", @"keypath should be keyPath1");
    XCTAssertEqualObjects(definition.rightKeyPath, @"keyPath2", @"keypath should be keyPath2");
    XCTAssertTrue(definition.direction == BNDBindingDirectionLeftToRight, @"assignment should be right");
    XCTAssertTrue(definition.transformDirection == BNDBindingTransformDirectionLeftToRight, @"transform direction should be right");
    XCTAssertTrue(definition.shouldSetInitialValues == YES, @"should set initial values");
    
    definition = [BNDParser parseBIND:@"keyPath1<~keyPath2"];
    XCTAssertEqualObjects(definition.leftKeyPath, @"keyPath1", @"keypath should be keyPath1");
    XCTAssertEqualObjects(definition.rightKeyPath, @"keyPath2", @"keypath should be keyPath2");
    XCTAssertTrue(definition.direction == BNDBindingDirectionRightToLeft, @"assignment should be left");
    XCTAssertTrue(definition.transformDirection == BNDBindingTransformDirectionRightToLeft, @"transform direction should be left");
    XCTAssertTrue(definition.shouldSetInitialValues == YES, @"should set initial values");
    
    definition = [BNDParser parseBIND:@"keyPath1<>keyPath2"];
    XCTAssertEqualObjects(definition.leftKeyPath, @"keyPath1", @"keypath should be keyPath1");
    XCTAssertEqualObjects(definition.rightKeyPath, @"keyPath2", @"keypath should be keyPath2");
    XCTAssertTrue(definition.direction == BNDBindingDirectionBoth, @"assignment should be none");
    XCTAssertTrue(definition.transformDirection == BNDBindingTransformDirectionLeftToRight, @"transform direction should be right");
    XCTAssertTrue(definition.shouldSetInitialValues == YES, @"should set initial values");

    definition = [BNDParser parseBIND:@"keyPath1!~>keyPath2"];
    XCTAssertEqualObjects(definition.leftKeyPath, @"keyPath1", @"keypath should be keyPath1");
    XCTAssertEqualObjects(definition.rightKeyPath, @"keyPath2", @"keypath should be keyPath2");
    XCTAssertTrue(definition.direction == BNDBindingDirectionLeftToRight, @"assignment should be right");
    XCTAssertTrue(definition.transformDirection == BNDBindingTransformDirectionLeftToRight, @"transform direction should be right");
    XCTAssertTrue(definition.shouldSetInitialValues == NO, @"should not set initial values");
    
    definition = [BNDParser parseBIND:@"keyPath1<~!keyPath2"];
    XCTAssertEqualObjects(definition.leftKeyPath, @"keyPath1", @"keypath should be keyPath1");
    XCTAssertEqualObjects(definition.rightKeyPath, @"keyPath2", @"keypath should be keyPath2");
    XCTAssertTrue(definition.direction == BNDBindingDirectionRightToLeft, @"assignment should be left");
    XCTAssertTrue(definition.transformDirection == BNDBindingTransformDirectionRightToLeft, @"transform direction should be left");
    XCTAssertTrue(definition.shouldSetInitialValues == NO, @"should not set initial values");
    
    definition = [BNDParser parseBIND:@"keyPath1<!>keyPath2"];
    XCTAssertEqualObjects(definition.leftKeyPath, @"keyPath1", @"keypath should be keyPath1");
    XCTAssertEqualObjects(definition.rightKeyPath, @"keyPath2", @"keypath should be keyPath2");
    XCTAssertTrue(definition.direction == BNDBindingDirectionBoth, @"assignment should be none");
    XCTAssertTrue(definition.transformDirection == BNDBindingTransformDirectionLeftToRight, @"transform direction should be right");
    XCTAssertTrue(definition.shouldSetInitialValues == NO, @"should not set initial values");
    
}

- (void)testBINDTransformerFromClass {
    BNDBindingModel *definition = [BNDParser parseBIND:@"keyPath1~>keyPath2|RPMToSpeedTransformer"];
    XCTAssertNotNil(definition.valueTransformer, @"value transformer should not be nil");
    XCTAssertTrue([definition.valueTransformer isKindOfClass:RPMToSpeedTransformer.class], @"transformer should be RPMToSpeedTransformer");
}

- (void)testBINDTransformerFromName {
    [NSValueTransformer setValueTransformer:[RPMToSpeedTransformer new]
                                    forName:@"RPMToSpeedTransformerName"];
    BNDBindingModel *definition = [BNDParser parseBIND:@"keyPath1~>keyPath2|RPMToSpeedTransformerName"];
    XCTAssertNotNil(definition.valueTransformer, @"value transformer should not be nil");
    XCTAssertTrue([definition.valueTransformer isKindOfClass:RPMToSpeedTransformer.class], @"transformer should be RPMToSpeedTransformer");
}

- (void)testBINDTransformDirectionModifierIsAssigned {
    BNDBindingModel *definition = [BNDParser parseBIND:@"rpm ~> speed | RPMToSpeedTransformer"];
    XCTAssertTrue(definition.transformDirection == BNDBindingTransformDirectionLeftToRight, @"Unmodified transform direction should be left to right.");
    
    definition = [BNDParser parseBIND:@"rpm ~> speed | !RPMToSpeedTransformer"];
    XCTAssertTrue(definition.transformDirection == BNDBindingTransformDirectionRightToLeft, @"Modified transform direction should be right to left.");
}

- (void)testBINDErroneousInput {
    XCTAssertThrows([BNDParser parseBIND:@"keyPath1~keyPath2"], @"should assert for no assignment symbol");
    XCTAssertThrows([BNDParser parseBIND:@"keyPath1~>"], @"should assert for no keypaths");
    XCTAssertThrows([BNDParser parseBIND:@"~>keyPath2"], @"should assert for no keypaths");
    XCTAssertThrows([BNDParser parseBIND:@"keyPath~>keyPath2|FooBar"], @"should assert for invalid transformer");
}

@end
