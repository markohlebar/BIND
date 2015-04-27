//
//  BNDTableViewController.m
//  BNDTableViewController
//
//  Created by Marko Hlebar on 26/04/2015.
//  Copyright (c) 2015 Marko Hlebar. All rights reserved.
//

#import "BNDTableViewController.h"
#import "BNDTableView.h"
#import "BNDConcreteViewModel.h"

@interface BNDTableViewController ()
@end

@implementation BNDTableViewController

- (void)viewDidLoad {
    //view and tableView properties are still nil when assigning the viewModel after init, hence this.
    self.viewModel = self.viewModel;
}

- (void)viewDidUpdateViewModel:(id<BNDViewModel>)viewModel {
    self.tableView.viewModel = viewModel;
}

@end
