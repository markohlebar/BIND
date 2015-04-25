//
//  MHNameTableCell.m
//  MVVM
//
//  Created by Marko Hlebar on 25/10/2014.
//  Copyright (c) 2014 Marko Hlebar. All rights reserved.
//

#import "MHNameTableCell.h"
#import "MHPersonNameViewModel.h"

@implementation MHNameTableCell
BINDINGS(MHPersonNameViewModel,
         BINDViewModel(name, ~>, textLabel.text),
         BINDViewModel(ID, ~>, detailTextLabel.text),
         BINDViewModelCommand(reverseNameCommand, onTouchUpInside),
         nil
         );
@end
