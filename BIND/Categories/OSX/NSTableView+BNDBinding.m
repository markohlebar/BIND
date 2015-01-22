//
//  NSTableView+BNDBinding.m
//  BIND
//
//  Created by Marko Hlebar on 29/11/2014.
//  Copyright (c) 2014 Marko Hlebar. All rights reserved.
//

#import "NSTableView+BNDBinding.h"

NSString *const NSTableViewReloadDataKeyPath = @"onReloadData";

@implementation NSTableView (BNDBinding)

- (void)handleSpecialKeyPath:(NSString *)keyPath {
    
}

- (void)setOnReloadData:(id)data {
    [self reloadData];
    [self didChangeValueForKey:NSTableViewReloadDataKeyPath];
}

- (NSTableView *)onReloadData {
    return self;
}

@end
