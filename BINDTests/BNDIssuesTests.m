//
//  BNDIssuesTests.m
//  BIND
//
//  Created by Marko Hlebar on 30/03/2015.
//  Copyright (c) 2015 Marko Hlebar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "BNDTestObjects.h"
#import "BNDConcreteViewModel.h"

@interface Issue18ViewModel : BNDViewModel
@property (nonatomic) BOOL hidden;
@end

@implementation Issue18ViewModel
@end

@interface Issue8Cell : TableViewCell
@end

@implementation Issue8Cell
BINDINGS(ViewModel,
         BINDViewModel(childViewModel, ~>, childCell.viewModel),
         nil);

@end

@interface BNDIssuesTests : XCTestCase

@end

@implementation BNDIssuesTests

/**
 *  Fix for https://github.com/markohlebar/BIND/issues/8
 */
- (void)testIssue8 {
    ViewModel *viewModel = [ViewModel new];
    viewModel.childViewModel = [ViewModel new];
    
    TableViewCell *cell = [Issue8Cell new];
    cell.childCell = [TableViewCell new];

    cell.viewModel = viewModel;
    
    BNDBinding *binding = cell.bindings[0];
    XCTAssertEqualObjects(binding.leftObject, viewModel, @"Left object should be the view model");
    XCTAssertEqualObjects(binding.rightObject, cell, @"Right object should be the cell");
}

- (void)testIssue18 {
    Issue18ViewModel *viewModel = [Issue18ViewModel new];
    TableViewCell *cell = [TableViewCell new];
    cell.hidden = NO;
    
    BINDT(viewModel, hidden, ~>, cell, hidden, NSNegateBooleanTransformerName);
    viewModel.hidden = NO;
    
    XCTAssertTrue(cell.hidden, @"Cell should be hidden");
}

@end
