//
//  BNDSpecialKeyPathHandling.h
//  BIND
//
//  Created by Marko Hlebar on 21/11/2014.
//  Copyright (c) 2014 Marko Hlebar. All rights reserved.
//

#import <Foundation/Foundation.h>

#if TARGET_OS_IPHONE
extern NSString *const UIButtonTouchUpInsideKeyPath;
#elif  TARGET_OS_MAC

#endif

@protocol BNDSpecialKeyPathHandling <NSObject>

- (void)handleSpecialKeyPath:(NSString *)keyPath;

@end
