//
//  MHNameViewModel.h
//  MVVM
//
//  Created by Marko Hlebar on 25/10/2014.
//  Copyright (c) 2014 Marko Hlebar. All rights reserved.
//

#import "BIND.h"
#ifndef MVVM_MHNameViewModel_h
#define MVVM_MHNameViewModel_h

@protocol MHNameViewModel <BNDViewModel>
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *hexColorCode;
@end

#endif
