//
//  MHTableViewController.m
//  MVVM
//
//  Created by Marko Hlebar on 25/10/2014.
//  Copyright (c) 2014 Marko Hlebar. All rights reserved.
//

#import "MHTableViewController.h"
#import "BNDConcreteViewModel.h"
#import "BNDView.h"
#import "MHNameViewModel.h"

@interface MHTableViewController ()
@end

@implementation MHTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.children.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id <BNDViewModel> viewModel = self.viewModel.children[indexPath.row];
    
    ///I am conveniently using the identifier here as a cell identifier. Someone else might choose
    ///to use the identifier only as way to identify different viewmodel instances,
    ///and present table view cells accordingly.
    NSString *identifier = viewModel.identifier;
    UITableViewCell <BNDView> *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:identifier
                                                     owner:self
                                                   options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.viewModel = viewModel;
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    id <BNDTableRowViewModel> viewModel = self.viewModel.children[indexPath.row];
    return viewModel.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
