//
//  MHTableDataController.h
//  MVVM
//
//  Created by Marko Hlebar on 25/10/2014.
//  Copyright (c) 2014 Marko Hlebar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MHNameViewModel.h"
#import "MHColorViewModel.h"
#import "BNDDataController.h"

@class MHPerson;
@class MHPersonFetcher;
@interface MHPersonDataController : NSObject <BNDDataController>
@property (nonatomic, strong) MHPersonFetcher *dataFetcher;
@end

