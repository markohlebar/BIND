//
//  MHColorViewModel.h
//  MVVM
//
//  Created by Marko Hlebar on 25/10/2014.
//  Copyright (c) 2014 Marko Hlebar. All rights reserved.
//

#ifndef MVVM_MHColorViewModel_h
#define MVVM_MHColorViewModel_h

#import "BNDViewModel.h"

@class UIColor;
@protocol MHColorViewModel <BNDViewModel>
@property (nonatomic, copy) UIColor *color;
@end

#endif
