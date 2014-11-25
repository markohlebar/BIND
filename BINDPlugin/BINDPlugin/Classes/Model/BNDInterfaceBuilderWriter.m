//
//  BNDInterfaceBuilderWriter.m
//  BINDPlugin
//
//  Created by Marko Hlebar on 23/11/2014.
//  Copyright (c) 2014 Marko Hlebar. All rights reserved.
//

#import "BNDInterfaceBuilderWriter.h"
#import "BNDInterfaceBuilderParser.h"
#import <Foundation/NSXMLDocument.h>

@interface BNDInterfaceBuilderWriter ()
@property (nonatomic, strong) BNDInterfaceBuilderParser *parser;
@property (nonatomic, strong) NSMutableArray *mutableBindings;
@property (nonatomic, strong) NSXMLDocument *xibDocument;
@end

@implementation BNDInterfaceBuilderWriter

+ (instancetype)writerWithXIBPathURL:(NSURL *)xibPathURL {
    NSAssert(xibPathURL, @"xibPathURL should not be nil");
    return [[self alloc] initWithXIBPathURL:xibPathURL];
}

- (instancetype)initWithXIBPathURL:(NSURL *)xibPathURL {
    self = [super init];
    if (self) {
        _xibPathURL = xibPathURL.copy;
    }
    return self;
}

- (NSArray *)bindings {
    return self.mutableBindings.copy;
}

- (void)addBinding:(BNDBindingDefinition *)binding {
    if (![self.mutableBindings containsObject:binding]) {
        [self.mutableBindings addObject:binding];
    }
}

- (void)removeBinding:(BNDBindingDefinition *)binding {
    [self.mutableBindings removeObject:binding];
}

- (void)removeAllBindings {
    [self.mutableBindings removeAllObjects];
}

- (void)write:(BNDErrorBlock)errorBlock {
    
}

- (NSXMLDocument *)openXIBDocument:(NSError **) error{
    self.xibDocument = [[NSXMLDocument alloc] initWithContentsOfURL:self.xibPathURL
                                                            options:NSXMLNodePreserveAll
                                                              error:error];
    return self.xibDocument;
}

- (void)reloadBindings:(BNDBindingsBlock)bindingsBlock {
    NSError *error = nil;
    NSXMLDocument *document = [self openXIBDocument:&error];
    if (error) {
        bindingsBlock(nil, error);
        return;
    }
    
    self.parser = [BNDInterfaceBuilderParser parserWithXIBDocument:document];
    __weak typeof(self) weakSelf = self;
    [self.parser parse:^(NSArray *bindings, NSError *error) {
        weakSelf.mutableBindings = bindings.mutableCopy;
        
        if (bindingsBlock) {
            bindingsBlock(bindings, error);
        }
    }];
}

@end
