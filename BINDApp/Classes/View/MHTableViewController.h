//
//  MHTableViewController.h
//  MVVM
//
//  Created by Marko Hlebar on 25/10/2014.
//  Copyright (c) 2014 Marko Hlebar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BIND.h"

@protocol MHTableViewDataController;
@interface MHTableViewController : BNDViewController
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@end
