//
//  BINDPlugin.h
//  BINDPlugin
//
//  Created by Marko Hlebar on 22/11/2014.
//  Copyright (c) 2014 Marko Hlebar. All rights reserved.
//

#import <AppKit/AppKit.h>

@interface BINDPlugin : NSObject

+ (instancetype)sharedPlugin;

@property (nonatomic, strong, readonly) NSBundle* bundle;
@end