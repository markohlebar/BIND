//
//  BNDViewModelTest.m
//  BIND
//
//  Created by Marko Hlebar on 25/06/2015.
//  Copyright © 2015 Marko Hlebar. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BNDConcreteViewModel.h"
#import "BNDMacros.h"

@interface TestModel : NSObject
@property (nonatomic, strong) NSString *text;
@end

@implementation TestModel
@end

@interface TestViewModel : BNDViewModel
@property (nonatomic, strong) NSString *text;
@end

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
@implementation TestViewModel
BINDINGS(TestModel,
         BINDModel(text, ~>, text),
         nil)
@end
#pragma clang diagnostic pop

@interface BNDViewModelTest : XCTestCase
@property (nonatomic, strong) BNDViewModel *viewModel;
@property (nonatomic, strong) NSObject *model;
@end

@implementation BNDViewModelTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    self.viewModel = [BNDViewModel viewModelWithModel:self.model];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    
    self.viewModel = nil;
}

- (void)testAssignsModelOnInitialization {
    XCTAssertEqual(self.viewModel.model, self.model, @"Model should be assigned after init.");
}

- (void)testAddingAChild {
    BNDViewModel *child = [BNDViewModel viewModelWithModel:nil];
    
    [self.viewModel addChild:child];
    
    XCTAssertEqual(self.viewModel.children.firstObject, child, @"Adds a child to children");
}

- (void)testAddingAChildThatIsNotBNDViewModelThrows {
    BNDViewModel *child = (BNDViewModel *)[NSObject new];
    
    XCTAssertThrows([self.viewModel addChild:child], @"Accepts only children which are BNDViewModel subclasses");
}

- (void)testRemovingAChild {
    BNDViewModel *child = [BNDViewModel viewModelWithModel:nil];
    
    [self.viewModel addChild:child];
    [self.viewModel removeChild:child];

    XCTAssertTrue(self.viewModel.children.count == 0, @"Adding and removing should yield 0 children");
}

- (void)testRemovingAllChildren {
    [self.viewModel addChild:[BNDViewModel viewModelWithModel:nil]];
    [self.viewModel addChild:[BNDViewModel viewModelWithModel:nil]];

    [self.viewModel removeAllChildren];
    
    XCTAssertTrue(self.viewModel.children.count == 0, @"Adding and removing all children should yield 0 children");
}

- (void)testBindingsAreLoadedAfterInitialization {
    TestModel *model = [TestModel new];
    model.text = @"Test";
    
    TestViewModel *viewModel = [TestViewModel viewModelWithModel:model];
    
    XCTAssertTrue(viewModel.bindings.count == 1, @"Bindings should load after initialization");
}

@end
