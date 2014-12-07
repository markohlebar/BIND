//
//  BNDBindingCreateCellViewModel.h
//  BINDPlugin
//
//  Created by Marko Hlebar on 06/12/2014.
//  Copyright (c) 2014 Marko Hlebar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BIND.h"

@protocol BNDBindingCreateCellViewModelCreator <NSObject>
- (void)createBinding;
@end

@interface BNDBindingCreateCellViewModel : NSObject <BNDTableRowViewModel>
@property (nonatomic, weak) id <BNDBindingCreateCellViewModelCreator> modelCreator;
@property (nonatomic) BNDAction createBinding;
@end
