//
//  MHPersonColorViewController.m
//  BIND
//
//  Created by Marko Hlebar on 25/04/2015.
//  Copyright (c) 2015 Marko Hlebar. All rights reserved.
//

#import "MHPersonColorViewController.h"
#import "BIND.h"
#import "MHAddPersonViewModel.h"

@interface MHPersonColorViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addBarButtonItem;
@end

@implementation MHPersonColorViewController
BINDINGS(MHAddPersonViewModel,
         BINDViewModelCommand(createPersonCommand, addBarButtonItem.onTouchUpInside),
         nil
);

@end
