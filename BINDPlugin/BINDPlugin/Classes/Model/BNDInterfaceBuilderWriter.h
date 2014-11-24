//
//  BNDInterfaceBuilderWriter.h
//  BINDPlugin
//
//  Created by Marko Hlebar on 23/11/2014.
//  Copyright (c) 2014 Marko Hlebar. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BNDBindingDefinition;
@interface BNDInterfaceBuilderWriter : NSObject
@property (nonatomic, copy, readonly) NSURL *xibPathURL;
@property (nonatomic, strong, readonly) NSArray *bindings;

+ (instancetype)writerWithXIBPathURL:(NSURL *)xibPathURL;
- (void)addBinding:(BNDBindingDefinition *)binding;
- (void)removeBinding:(BNDBindingDefinition *)binding;
- (void)removeAllBindings;

@end
