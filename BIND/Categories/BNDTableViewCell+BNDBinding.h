//
//  BNDTableViewCell+BNDBinding.h
//  BIND
//
//  Created by Marko Hlebar on 06/12/2014.
//  Copyright (c) 2014 Marko Hlebar. All rights reserved.
//

#import "BNDConcreteView.h"
#import "BNDSpecialKeyPathHandling.h"
#import "BNDBindingTypes.h"

extern NSString *const BNDTableViewCellTouchUpInsideKeyPath;

@interface _BNDTableViewCell (BNDBinding) <BNDSpecialKeyPathHandling>

- (BNDTableViewCell *)onTouchUpInside;

@end
