//
//  BNDTableViewUpdater.m
//  BNDTableViewController
//
//  Created by Marko Hlebar on 26/04/2015.
//  Copyright (c) 2015 Marko Hlebar. All rights reserved.
//

#import "BNDTableViewUpdater.h"
#import "BNDTableView.h"
#import "BIND.h"
#import "BNDViewModel.h"

@interface BNDTableViewUpdater ()
@property (nonatomic, strong) BNDBinding *observeBinding;
@end

@implementation BNDTableViewUpdater

+ (instancetype)updaterWithTableView:(BNDTableView *)tableView {
    return [[self alloc] initWithTableView:tableView];
}

- (instancetype)initWithTableView:(BNDTableView *)tableView {
    self = [super init];
    if (self) {
        _tableView = tableView;
    }
    return self;
}

- (void)updateWithViewModel:(id <BNDTableViewModel> )viewModel {
    [self doesNotRecognizeSelector:_cmd];
}

@end

@implementation BNDTableViewReloadDataUpdater

- (void)updateWithViewModel:(id<BNDTableViewModel>)viewModel {
    [self.observeBinding unbind];
    __weak typeof(self) weakSelf = self;
    self.observeBinding = [BINDO(viewModel, subViewModels) observe:^(id observable, id value, NSDictionary *observationInfo) {
        [weakSelf.tableView reloadData];
    }];
}

@end

@interface BNDTableViewFlowDataUpdater ()
@property (nonatomic, strong) id <BNDTableViewModel> lastViewModel;
@end

@implementation BNDTableViewFlowDataUpdater

- (void)updateWithViewModel:(id<BNDTableViewModel>)viewModel {
    [self.tableView beginUpdates];
    
    
    [self.tableView endUpdates];
    
    self.lastViewModel = viewModel;
}

- (NSArray *)insertIndexPathsForViewModel:(id<BNDTableViewModel>)viewModel {
    return nil;
}

- (NSArray *)deleteIndexPathsForViewModel:(id<BNDTableViewModel>)viewModel {
    return nil;
}

@end
