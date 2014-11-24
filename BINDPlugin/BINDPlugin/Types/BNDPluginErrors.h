//
//  BNDPluginErrors.h
//  BINDPlugin
//
//  Created by Marko Hlebar on 23/11/2014.
//  Copyright (c) 2014 Marko Hlebar. All rights reserved.
//

#import <Foundation/Foundation.h>
#ifndef BINDPlugin_BNDPluginErrors_h
#define BINDPlugin_BNDPluginErrors_h

typedef NS_ENUM(NSUInteger, BNDPluginErrorCode) {
    BNDPluginErrorNoError = 0,
    BNDPluginErrorMissingBindingsErrorCode = 1,
};

static NSString *const BINDPluginErrorDomain = @"BINDPluginErrorDomain";

#define BINDPluginError(__CODE__, __DESCRIPTION__) \
[NSError errorWithDomain:BINDPluginErrorDomain \
                    code:__CODE__ \
                userInfo:@{NSLocalizedDescriptionKey : __DESCRIPTION__}]

#endif
