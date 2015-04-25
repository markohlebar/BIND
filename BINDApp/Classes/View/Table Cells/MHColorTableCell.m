//
//  MHColorTableCell.m
//  MVVM
//
//  Created by Marko Hlebar on 25/10/2014.
//  Copyright (c) 2014 Marko Hlebar. All rights reserved.
//

#import "MHColorTableCell.h"
#import "MHColorViewModel.h"

@implementation MHColorTableCell
BINDINGS(MHColorViewModel,
         BINDViewModel(color, ~>, contentView.backgroundColor),
         nil);
@end
