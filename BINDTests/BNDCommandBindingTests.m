//
//  BNDCommandBindingTests.m
//  BIND
//
//  Created by Marko Hlebar on 20/04/2015.
//  Copyright (c) 2015 Marko Hlebar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "BNDCommandBinding.h"
#import "BNDTestObjects.h"
#import "BNDTableViewCell+BNDBinding.h"

@interface BNDCommandBindingTests : XCTestCase

@end

@implementation BNDCommandBindingTests {
    BNDCommandBinding *_binding;
    ViewModel *_viewModel;
    TableViewCell *_cell;
}

- (void)setUp {
    [super setUp];
    
    _viewModel = [ViewModel new];
    _cell = [TableViewCell new];
}

- (void)tearDown {
    _viewModel = nil;
    _cell = nil;
    
    [super tearDown];
}

- (void)XtestCommandGetsExecuted {
    _binding = [BNDCommandBinding bindingWithCommandKeyPath:@"command"
                                              actionKeyPath:@"onTouchUpInside"];
    [_binding bindLeft:_viewModel withRight:_cell];
    
    _cell.onTouchUpInside = _cell;
    
    XCTAssertTrue(_viewModel.command.isExecuted, @"Touching the cell should execute the command");
}

@end
