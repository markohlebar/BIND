//
//  BNDTableViewCell+BNDBinding.h
//  BIND
//
//  Created by Marko Hlebar on 06/12/2014.
//  Copyright (c) 2014 Marko Hlebar. All rights reserved.
//

#import "BNDConcreteView.h"
#import "BNDSpecialKeyPathHandling.h"
#import "BNDMacros.h"

extern NSString * const BNDTableViewCellTouchUpInsideBindingKeyPath;

@interface _BNDTableViewCell (BNDBinding) <BNDSpecialKeyPathHandling>
@property (nonatomic) _BNDTableViewCell *onTouchUpInside;
@end
