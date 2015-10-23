//
//  MHTableViewController.m
//  MVVM
//
//  Created by Marko Hlebar on 02/11/2014.
//  Copyright (c) 2014 Marko Hlebar. All rights reserved.
//

#import "MHTableViewController.h"

@implementation MHTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView = (UITableView *)self.view;
}

- (void)viewWillAppear:(BOOL)animated {
    __weak typeof(self) weakSelf = self;
    [self.dataController updateWithContext:nil viewModelsHandler:^(NSArray *viewModels, NSError *error) {
        weakSelf.viewModel = [viewModels firstObject];
        [weakSelf.tableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.tableViewModel.sectionViewModels.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <BNDTableSectionViewModel> sectionViewModel = self.tableViewModel.sectionViewModels[section];
    return sectionViewModel.rowViewModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id <BNDTableSectionViewModel> sectionViewModel = self.tableViewModel.sectionViewModels[indexPath.section];
    id <BNDViewModel> viewModel = sectionViewModel.rowViewModels[indexPath.row];
    
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

- (id <BNDTableViewModel>) tableViewModel {
    return (id <BNDTableViewModel>)self.viewModel;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    id <BNDTableSectionViewModel> sectionViewModel = self.tableViewModel.sectionViewModels[section];
    return sectionViewModel.title;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    id <BNDTableSectionViewModel> sectionViewModel = self.tableViewModel.sectionViewModels[section];
    return sectionViewModel.cellHeight;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    id <BNDTableSectionViewModel> sectionViewModel = self.tableViewModel.sectionViewModels[indexPath.section];
    id <BNDTableRowViewModel> viewModel = sectionViewModel.rowViewModels[indexPath.row];
    return viewModel.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
