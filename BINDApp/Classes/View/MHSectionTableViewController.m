//
//  MHSectionTableViewController.m
//  MVVM
//
//  Created by Marko Hlebar on 02/11/2014.
//  Copyright (c) 2014 Marko Hlebar. All rights reserved.
//

#import "MHSectionTableViewController.h"
#import "BNDViewModel.h"
#import "BNDView.h"
#import "MHNameViewModel.h"

@interface MHTableViewController ()
@property (nonatomic, copy) NSArray *viewModels;
@end

@interface MHSectionTableViewController ()

@end

@implementation MHSectionTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return self.viewModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id <BNDTableSectionViewModel> sectionViewModel = self.viewModels[indexPath.section];
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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    id <BNDTableSectionViewModel> viewModel = self.viewModels[section];
    return viewModel.title;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    id <BNDTableSectionViewModel> viewModel = self.viewModels[section];
    return viewModel.cellHeight;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    id <BNDTableSectionViewModel> sectionViewModel = self.viewModels[indexPath.section];
    id <BNDTableRowViewModel> viewModel = sectionViewModel.rowViewModels[indexPath.row];
    return viewModel.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    id <BNDTableSectionViewModel> sectionViewModel = self.viewModels[indexPath.section];
    id <MHNameViewModel> viewModel = sectionViewModel.rowViewModels[indexPath.row];
    viewModel.name = @"DUDE!!!";
}

@end
