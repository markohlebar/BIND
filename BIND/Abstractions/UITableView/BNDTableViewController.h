//
//  BNDTableViewController.h
//  BNDTableViewController
//
//  Created by Marko Hlebar on 26/04/2015.
//  Copyright (c) 2015 Marko Hlebar. All rights reserved.
//

#import "BNDConcreteView.h"

@class BNDTableView;
@interface BNDTableViewController : BNDViewController
@property (nonatomic, strong, readwrite) IBOutlet BNDTableView *tableView;
@end
