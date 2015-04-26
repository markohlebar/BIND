//
//  BNDTableView.m
//  BNDTableViewController
//
//  Created by Marko Hlebar on 26/04/2015.
//  Copyright (c) 2015 Marko Hlebar. All rights reserved.
//

#import "BNDTableView.h"
#import "BNDTableViewUpdater.h"
#import "BNDViewModel.h"
#import "BNDView.h"
#import "BNDMacros.h"
#import "BNDTableViewModel.h"

@interface BNDTableView () <UITableViewDataSource, UITableViewDelegate>
@property (strong) NSArray *sections;
@end

@implementation BNDTableView
BND_VIEW_IMPLEMENT_SET_VIEW_MODEL
BINDINGS(BNDTableViewModel,
         BINDViewModel(children, ~>, sections),
         nil)

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self claimCallbacks];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self claimCallbacks];
    }
    return self;
}

- (void)claimCallbacks {
    self.delegate = self;
    self.dataSource = self;
}

- (void)viewDidUpdateViewModel:(id<BNDTableViewModel>)viewModel {
    NSAssert([viewModel conformsToProtocol:@protocol(BNDTableViewModel)], @"The view model should be the table view model");
    
    [self.updater updateWithViewModel:viewModel];
}

- (void)setSections:(NSArray *)sections {
    if (self.viewModel) {
        [self viewDidUpdateViewModel:self.viewModel];
    }
}

- (BNDTableViewUpdater *)updater {
    if (!_updater) {
        _updater = [BNDTableViewReloadDataUpdater updaterWithTableView:self];
    }
    return _updater;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.sections[section] rowViewModels] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id <BNDTableSectionViewModel> sectionViewModel = self.sections[indexPath.section];
    id <BNDViewModel> rowViewModel = sectionViewModel.rowViewModels[indexPath.row];
    
    NSString *identifier = rowViewModel.identifier;
    UITableViewCell <BNDView> *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:identifier
                                                     owner:self
                                                   options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.viewModel = rowViewModel;
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    id <BNDTableSectionViewModel> viewModel = self.sections[section];
    return [viewModel respondsToSelector:@selector(title)] ? viewModel.title : nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    id <BNDTableSectionViewModel> viewModel = self.sections[section];
    return [viewModel respondsToSelector:@selector(cellHeight)] ? viewModel.cellHeight : 0;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    id <BNDTableSectionViewModel> sectionViewModel = self.sections[indexPath.section];
    id <BNDTableRowViewModel> viewModel = sectionViewModel.rowViewModels[indexPath.row];
    return viewModel.cellHeight;
}

- (id <BNDTableRowViewModel> )rowAtIndexPath:(NSIndexPath *)indexPath {
    id <BNDTableSectionViewModel> sectionViewModel = self.sections[indexPath.section];
    return sectionViewModel.rowViewModels[indexPath.row];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedRow = [self rowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedRow = nil;
}

#pragma mark - Private

- (NSArray *)sections {
    id <BNDTableViewModel> tableViewModel = (id <BNDTableViewModel>)self.viewModel;
    return tableViewModel.sectionViewModels;
}

@end
