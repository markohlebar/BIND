//
//  MHNameTableCell.m
//  MVVM
//
//  Created by Marko Hlebar on 25/10/2014.
//  Copyright (c) 2014 Marko Hlebar. All rights reserved.
//

#import "MHNameTableCell.h"
#import "BNDBinding.h"
#import "MHPersonNameViewModel.h"
#import "MHReversePersonNameCommand.h"

@implementation MHNameTableCell
BINDINGS(MHPersonNameViewModel,
         BINDViewModel(name, ->, textLabel.text),
         BINDCommand(self, onTouchUpInside, viewModel.reverseNameCommand).lock,
         nil
         );
@end
