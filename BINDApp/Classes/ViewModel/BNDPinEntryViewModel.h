//
//  BNDPinEntryViewModel.h
//  BIND
//
//  Created by Marko Hlebar on 21/11/2014.
//  Copyright (c) 2014 Marko Hlebar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BNDViewModel.h"

@interface BNDPinEntryViewModel : NSObject <BNDViewModel>
@property (nonatomic, strong) UIButton *input;
@end
