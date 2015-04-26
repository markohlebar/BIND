//
//  BNDTableViewController.m
//  BNDTableViewController
//
//  Created by Marko Hlebar on 26/04/2015.
//  Copyright (c) 2015 Marko Hlebar. All rights reserved.
//

#import "BNDTableViewController.h"
#import "BNDTableView.h"

@interface BNDTableViewController ()
@end

@implementation BNDTableViewController

//- (void)loadView {
//    self.tableView = [BNDTableView new];
//    self.view = self.tableView;
//}

- (void)viewDidLoad {
    [self viewDidUpdateViewModel:self.viewModel];
}

- (void)viewDidUpdateViewModel:(id<BNDViewModel>)viewModel {
    if (viewModel) {
        self.tableView.viewModel = viewModel;
    }
}

@end
