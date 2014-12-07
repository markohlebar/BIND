//
//  BNDBindingCellViewModel.h
//  BINDPlugin
//
//  Created by Marko Hlebar on 29/11/2014.
//  Copyright (c) 2014 Marko Hlebar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BIND.h"

@interface BNDBindingCellViewModel : NSObject <BNDTableRowViewModel>
@property (nonatomic, copy) NSString *BIND;
@end
