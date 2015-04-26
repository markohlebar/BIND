//
//  UIBarButtonItem+BNDBinding.h
//  BIND
//
//  Created by Marko Hlebar on 25/04/2015.
//  Copyright (c) 2015 Marko Hlebar. All rights reserved.
//

#if TARGET_OS_IPHONE

#import <UIKit/UIKit.h>
#import "BNDSpecialKeyPathHandling.h"

@interface UIBarButtonItem (BNDBinding) <BNDSpecialKeyPathHandling>
@property (nonatomic) UIBarButtonItem *onTouchUpInside;
@end

#endif
