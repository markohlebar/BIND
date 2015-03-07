//
//  MHTableViewController.m
//  MVVM
//
//  Created by Marko Hlebar on 25/10/2014.
//  Copyright (c) 2014 Marko Hlebar. All rights reserved.
//

#import "MHTableViewController.h"
#import "BNDViewModel.h"
#import "BNDView.h"
#import "MHNameViewModel.h"

@interface MHTableViewController ()
@property (nonatomic, copy) NSArray *viewModels;
@end

@implementation MHTableViewController {
    NSObject <BNDDataController> *_dataController;
}
@synthesize dataController = _dataController;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __weak typeof(self) weakSelf = self;
    [_dataController updateWithContext:nil viewModelsHandler:^(NSArray *viewModels, NSError *error) {
        weakSelf.viewModels = viewModels;
        [weakSelf.tableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id <BNDViewModel> viewModel = self.viewModels[indexPath.row];
    
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
    id <BNDTableRowViewModel> viewModel = self.viewModels[indexPath.row];
    return viewModel.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    id <MHNameViewModel> viewModel = self.viewModels[indexPath.row];
    if ([viewModel respondsToSelector:@selector(setName:)]) {
        viewModel.name = @"DUDE!!!";
    }
}

@end
