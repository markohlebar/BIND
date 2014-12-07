//
//  BNDInterfaceBuilderWriter.h
//  BINDPlugin
//
//  Created by Marko Hlebar on 23/11/2014.
//  Copyright (c) 2014 Marko Hlebar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BNDPluginTypes.h"

@protocol BNDInterfaceBuilderWriterDelegate <NSObject>
- (void)writer:(id)writer didUpdateWithBindings:(NSArray *)bindings;
@end

@class BNDBindingDefinition;
@interface BNDInterfaceBuilderWriter : NSObject
@property (nonatomic, copy, readonly) NSURL *xibPathURL;
@property (nonatomic, weak) id <BNDInterfaceBuilderWriterDelegate> delegate;
@property (nonatomic, strong, readonly) NSArray *bindings;
@property (nonatomic, strong, readonly) NSArray *bindingOutlets;

+ (instancetype)writerWithXIBPathURL:(NSURL *)xibPathURL;

- (NSArray *)reloadBindings:(NSError **)error;

- (void)createBinding;

- (void)addBinding:(BNDBindingDefinition *)binding;

- (void)removeBinding:(BNDBindingDefinition *)binding;

- (void)removeAllBindings;

- (void)write:(BNDErrorBlock)errorBlock;

@end
