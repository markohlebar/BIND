//
//  NSTextField+BNDBinding.h
//  BIND
//
//  Created by Marko Hlebar on 13/12/2014.
//  Copyright (c) 2014 Marko Hlebar. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "BNDSpecialKeyPathHandling.h"

extern NSString *const NSTextFieldTextKeyPath;

@interface NSTextField (BNDBinding) <BNDSpecialKeyPathHandling>
@property (nonatomic, strong) NSString *text;
@end
