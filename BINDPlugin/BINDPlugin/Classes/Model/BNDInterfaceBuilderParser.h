//
//  BNDInterfaceBuilderParser.h
//  BINDPlugin
//
//  Created by Marko Hlebar on 23/11/2014.
//  Copyright (c) 2014 Marko Hlebar. All rights reserved.
//

#import <AppKit/AppKit.h>

typedef void(^BNDBindingsBlock)(NSArray *bindings, NSError *error);

@interface BNDInterfaceBuilderParser : NSObject
@property (nonatomic, readonly, copy) NSURL *xibPathURL;

+ (instancetype)parserWithXIBPathURL:(NSURL *)xibPathURL;
- (void)parse:(BNDBindingsBlock)bindingsBlock;

@end
