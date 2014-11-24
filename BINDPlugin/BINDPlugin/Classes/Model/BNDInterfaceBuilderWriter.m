//
//  BNDInterfaceBuilderWriter.m
//  BINDPlugin
//
//  Created by Marko Hlebar on 23/11/2014.
//  Copyright (c) 2014 Marko Hlebar. All rights reserved.
//

#import "BNDInterfaceBuilderWriter.h"
#import "BNDInterfaceBuilderParser.h"

@interface BNDInterfaceBuilderWriter ()
@property (nonatomic, strong) BNDInterfaceBuilderParser *parser;
@property (nonatomic, strong) NSArray *bindings;
@end

@implementation BNDInterfaceBuilderWriter

+ (instancetype)writerWithXIBPathURL:(NSURL *)xibPathURL {
    NSAssert(xibPathURL, @"xibPathURL should not be nil");
    return [[self alloc] initWithXIBPathURL:xibPathURL];
}

- (instancetype)initWithXIBPathURL:(NSURL *)xibPathURL {
    self = [super init];
    if (self) {
        _parser = [BNDInterfaceBuilderParser parserWithXIBPathURL:xibPathURL];
        _xibPathURL = xibPathURL.copy;
        _bindings = [NSArray array];
    }
    return self;
}

- (void)addBinding:(BNDBindingDefinition *)binding {
    
    self.bindings = [self.bindings arrayByAddingObject:binding];
}

- (void)removeBinding:(BNDBindingDefinition *)binding {

}

- (void)removeAllBindings {

}

@end
