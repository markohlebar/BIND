//
//  MHPersonColorViewModel.h
//  MVVM
//
//  Created by Marko Hlebar on 02/11/2014.
//  Copyright (c) 2014 Marko Hlebar. All rights reserved.
//

#import "MHPersonViewModel.h"
#import "MHColorViewModel.h"

@interface MHPersonColorViewModel : MHPersonViewModel <MHColorViewModel>
@property (nonatomic, copy) UIColor *color;
@end
