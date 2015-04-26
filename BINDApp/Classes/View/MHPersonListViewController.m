//
//  MHPersonListViewController.m
//  BIND
//
//  Created by Marko Hlebar on 25/04/2015.
//  Copyright (c) 2015 Marko Hlebar. All rights reserved.
//

#import "MHPersonListViewController.h"
#import "BIND.h"
#import "MHPersonListViewModel.h"

@interface MHPersonListViewController ()
@property (strong, nonatomic) UIBarButtonItem *addBarButtonItem;
@end

@implementation MHPersonListViewController
BINDINGS(MHPersonListViewModel,
         BINDViewModelCommand(createPersonCommand, addBarButtonItem.onTouchUpInside),
         nil)

- (UIBarButtonItem *)addBarButtonItem {
    if (!_addBarButtonItem) {
        _addBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                          target:nil
                                                                          action:nil];
        self.navigationItem.rightBarButtonItem = _addBarButtonItem;
    }
    return _addBarButtonItem;
}

@end
