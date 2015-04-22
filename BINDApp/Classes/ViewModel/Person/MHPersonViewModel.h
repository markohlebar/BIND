//
//  MHPersonViewModel.h
//  MVVM
//
//  Created by Marko Hlebar on 02/11/2014.
//  Copyright (c) 2014 Marko Hlebar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BNDConcreteViewModel.h"

@class MHPerson;
@interface MHPersonViewModel : BNDViewModel
@property (nonatomic, strong, readonly) MHPerson *person;
@end
