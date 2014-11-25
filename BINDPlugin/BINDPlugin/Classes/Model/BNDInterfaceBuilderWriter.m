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
#import "BNDBindingDefinition.h"
#import "BNDPluginErrors.h"

static NSString * const BNDObjectsXpath = @"document/objects";

@interface BNDInterfaceBuilderWriter ()
@property (nonatomic, strong) BNDInterfaceBuilderParser *parser;
@property (nonatomic, strong) NSArray *bindings;
@property (nonatomic, strong) NSMutableArray *additionalBindings;
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
        _additionalBindings = [NSMutableArray new];
    }
    return self;
}

- (NSArray *)bindings {
    return [_bindings arrayByAddingObjectsFromArray:self.additionalBindings];
}

- (void)addBinding:(BNDBindingDefinition *)binding {
    if ([self.bindings containsObject:binding]) {
        return;
    }
    
    if (![self.additionalBindings containsObject:binding]) {
        [self.additionalBindings addObject:binding];
    }
}

- (void)removeBinding:(BNDBindingDefinition *)binding {
    [self.additionalBindings removeObject:binding];
    
    NSMutableArray *bindings = self.bindings.mutableCopy;
    [bindings removeObject:binding];
    
    self.bindings = bindings.copy;
}

- (void)removeAllBindings {
    [self.additionalBindings removeAllObjects];
    self.bindings = [NSArray new];
}

- (void)write:(BNDErrorBlock)errorBlock {
    NSXMLElement *objectsElement = self.objectsElement;
    
    for (BNDBindingDefinition *bindingDefinition in self.additionalBindings) {
        [objectsElement addChild:bindingDefinition.element];
    }
    
    NSData* xmlData = [self.xibDocument XMLDataWithOptions:NSXMLNodePrettyPrint];
    if (![xmlData writeToURL:self.xibPathURL atomically:YES]) {
        if (errorBlock) {
            __block NSString *errorMessage = [NSString stringWithFormat:@"Could not write to file %@", self.xibPathURL];
            errorBlock(BINDPluginError(BNDPluginErrorWriteErrorCode, errorMessage));
        }
    }
    else if (errorBlock) {
        errorBlock(nil);
    }
}

- (NSXMLElement *)objectsElement {
    NSArray *objectsArray = [self.xibDocument nodesForXPath:BNDObjectsXpath
                                                      error:nil];
    return [objectsArray firstObject];
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
        if(bindingsBlock) bindingsBlock(nil, error);
        return;
    }
    
    self.parser = [BNDInterfaceBuilderParser parserWithXIBDocument:document];
    __weak typeof(self) weakSelf = self;
    [self.parser parse:^(NSArray *bindings, NSError *error) {
        weakSelf.bindings = bindings;
        
        if (bindingsBlock) {
            bindingsBlock(bindings, error);
        }
    }];
}

@end
