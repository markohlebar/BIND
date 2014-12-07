//
//  BNDCrashTests.m
//  BIND
//
//  Created by Marko Hlebar on 07/12/2014.
//  Copyright (c) 2014 Marko Hlebar. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BNDTestObjects.h"
#import "BNDBinding.h"

@interface BNDCrashTests : XCTestCase

@end

@implementation BNDCrashTests

- (void)testShouldNotCrashWhenAssigningNewViewModel {
    TableViewCell *cell = nil;
    BNDBinding *binding = nil;
    
    cell = [[TableViewCell alloc] init];
    binding = [BNDBinding bindingWithBIND:@"viewModel.text -> textLabel.text"];
    cell.bindings = @[binding];
    
    ViewModel *viewModel = [ViewModel new];
    cell.viewModel = viewModel;
    
    ViewModel *viewModel2 = [ViewModel new];
    XCTAssertNoThrow([cell setViewModel:viewModel2], @"Should not throw an exception when assigning new view model");
}

- (void)testShouldNotCrashWhenAssigningNewViewModelAndDeallocingCell {
    TableViewCell *cell = nil;
    BNDBinding *binding = nil;
    
    cell = [[TableViewCell alloc] init];
    binding = [BNDBinding bindingWithBIND:@"viewModel.text -> textLabel.text"];
    cell.bindings = @[binding];
    
    ViewModel *viewModel = [ViewModel new];
    cell.viewModel = viewModel;
    
    ViewModel *viewModel2 = [ViewModel new];
    cell.viewModel = viewModel2;
    
    XCTAssertNoThrow(cell = nil, @"Should not throw an exception when deallocing cell");
}

@end
