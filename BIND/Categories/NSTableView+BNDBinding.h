//
//  NSTableView+BNDBinding.h
//  BIND
//
//  Created by Marko Hlebar on 29/11/2014.
//  Copyright (c) 2014 Marko Hlebar. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "BNDSpecialKeyPathHandling.h"

extern NSString *const NSTableViewReloadDataKeyPath;

@interface NSTableView (BNDBinding) <BNDSpecialKeyPathHandling>

@property (nonatomic) NSTableView *onReloadData;

@end
