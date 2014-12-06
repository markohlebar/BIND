//
//  BNDBindingListViewModel.h
//  BINDPlugin
//
//  Created by Marko Hlebar on 29/11/2014.
//  Copyright (c) 2014 Marko Hlebar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BIND.h"

@interface BNDBindingListViewModel : NSObject <BNDTableSectionViewModel>
@property (nonatomic, strong) NSArray *rowViewModels;
@property (nonatomic, strong) id createBinding;
@end
