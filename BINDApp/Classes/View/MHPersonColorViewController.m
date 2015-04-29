//
//  MHPersonColorViewController.m
//  BIND
//
//  Created by Marko Hlebar on 25/04/2015.
//  Copyright (c) 2015 Marko Hlebar. All rights reserved.
//

#import "MHPersonColorViewController.h"
#import "BIND.h"
#import "MHPersonColorViewModel.h"

@interface MHPersonColorViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addBarButtonItem;
@end

@implementation MHPersonColorViewController
BINDINGS(MHPersonColorViewModel,
         BINDCommand(createPersonCommand, addBarButtonItem.onTouchUpInside),
         nil
);

@end
