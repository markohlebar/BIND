//
//  BNDSpecialKeyPathHandling.h
//  BIND
//
//  Created by Marko Hlebar on 21/11/2014.
//  Copyright (c) 2014 Marko Hlebar. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *const BNDBindingTouchUpInsideKeyPath = @"onTouchUpInside";

@protocol BNDSpecialKeyPathHandling <NSObject>

- (void)handleSpecialKeyPath:(NSString *)keyPath;

@end
