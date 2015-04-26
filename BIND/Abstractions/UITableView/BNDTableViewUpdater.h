//
//  BNDTableViewUpdater.h
//  BNDTableViewController
//
//  Created by Marko Hlebar on 26/04/2015.
//  Copyright (c) 2015 Marko Hlebar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BNDViewModel.h"

@class BNDTableView;
@interface BNDTableViewUpdater : NSObject
@property (nonatomic, weak, readonly) BNDTableView *tableView;

+ (instancetype)updaterWithTableView:(BNDTableView *)tableView;
- (void)updateWithViewModel:(id <BNDTableViewModel> )viewModel;

@end

@interface BNDTableViewReloadDataUpdater : BNDTableViewUpdater

@end

@interface BNDTableViewFlowDataUpdater : BNDTableViewUpdater

@end
