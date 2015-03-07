//
//  MHPersonSectionViewModel.h
//  MVVM
//
//  Created by Marko Hlebar on 02/11/2014.
//  Copyright (c) 2014 Marko Hlebar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BNDViewModel.h"

@interface MHPersonSectionViewModel : NSObject <BNDTableSectionViewModel>
@property (nonatomic, strong) NSArray *rowViewModels;
@property (nonatomic, copy) NSString *title;
@end
