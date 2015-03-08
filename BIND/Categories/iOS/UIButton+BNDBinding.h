//
//  UIButton+BNDBinding.h
//  BIND
//
//  Created by Marko Hlebar on 20/11/2014.
//  Copyright (c) 2014 Marko Hlebar. All rights reserved.
//

#if TARGET_OS_IPHONE

#import <UIKit/UIKit.h>
#import "BNDSpecialKeyPathHandling.h"

@interface UIButton (BNDBinding) <BNDSpecialKeyPathHandling>
@property (nonatomic) UIButton *onTouchUpInside;
@end

#endif
