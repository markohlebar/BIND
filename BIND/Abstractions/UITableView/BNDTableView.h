//
//  BNDTableView.h
//  BNDTableViewController
//
//  Created by Marko Hlebar on 26/04/2015.
//  Copyright (c) 2015 Marko Hlebar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BNDViewModel.h"
#import "BNDView.h"

@class BNDTableViewUpdater;
@interface BNDTableView : UITableView <BNDView>

/**
 *  The selected row of the table view.
 *  Observe this property to get the selections.
 */
@property (nonatomic, weak) id <BNDTableRowViewModel> selectedRow;

/**
 *  An update strategy for this table view.
 *  @default BNDTableViewReloadDataUpdater
 */
@property (nonatomic, strong) BNDTableViewUpdater *updater;

@end
