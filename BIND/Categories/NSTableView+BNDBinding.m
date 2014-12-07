//
//  NSTableView+BNDBinding.m
//  BIND
//
//  Created by Marko Hlebar on 29/11/2014.
//  Copyright (c) 2014 Marko Hlebar. All rights reserved.
//

#import "NSTableView+BNDBinding.h"

@implementation NSTableView (BNDBinding)

- (void)handleSpecialKeyPath:(NSString *)keyPath {
    
}

- (void)setOnReloadData:(id)data {
    [self reloadData];
    [self didChangeValueForKey:@"onReloadData"];
}

- (NSTableView *)onReloadData {
    return self;
}

@end
