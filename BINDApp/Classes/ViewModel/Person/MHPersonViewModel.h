//
//  MHPersonViewModel.h
//  MVVM
//
//  Created by Marko Hlebar on 02/11/2014.
//  Copyright (c) 2014 Marko Hlebar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BNDViewModel.h"

@class MHPerson;
@interface MHPersonViewModel : NSObject <BNDViewModel>
@property (nonatomic, strong, readonly) MHPerson *person;
@end
