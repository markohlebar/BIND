//
//  MHPersonNameViewModel.h
//  MVVM
//
//  Created by Marko Hlebar on 02/11/2014.
//  Copyright (c) 2014 Marko Hlebar. All rights reserved.
//

#import "MHPersonViewModel.h"
#import "MHNameViewModel.h"

@interface MHPersonNameViewModel : MHPersonViewModel <MHNameViewModel>
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *ID;
@end
