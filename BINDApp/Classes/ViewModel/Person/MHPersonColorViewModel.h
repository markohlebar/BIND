//
//  MHPersonColorViewModel.h
//  MVVM
//
//  Created by Marko Hlebar on 02/11/2014.
//  Copyright (c) 2014 Marko Hlebar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BIND.h"

@interface MHPersonColorViewModel : BNDViewModel
@property (nonatomic, strong) id <BNDCommand> createPersonCommand;
@end
