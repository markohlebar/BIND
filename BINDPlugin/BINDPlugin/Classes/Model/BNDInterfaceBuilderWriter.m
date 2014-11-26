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
#import "BNDBindingsOutletDefinition.h"

static NSString * const BNDObjectsXpath = @"document/objects";
static NSString * const BNDFileOwnerConnectionsXpath = @"document/objects/placeholder[@placeholderIdentifier='IBFilesOwner']";

@interface BNDInterfaceBuilderWriter ()
@property (nonatomic, strong) BNDInterfaceBuilderParser *parser;

@property (nonatomic, strong) NSMutableArray *mutableBindings;
@property (nonatomic, strong) NSMutableArray *mutablebindingOutlets;

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
        _mutableBindings = [NSMutableArray new];
        _mutablebindingOutlets = [NSMutableArray new];
    }
    return self;
}

- (NSArray *)bindings {
    return self.mutableBindings.copy;
}

- (NSArray *)bindingOutlets {
    return self.mutablebindingOutlets.copy;
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
    [self addBindingsToObjectsElement];
    
    NSError *error = [self writeXIBSocument];
    if (errorBlock) {
        errorBlock(error);
    }
}

- (void)addBindingsToObjectsElement {
    NSXMLElement *objectsElement = self.objectsElement;
    
    for (BNDBindingDefinition *bindingDefinition in self.mutableBindings) {
        if (![self element:objectsElement containsObjectWithID:bindingDefinition.ID]) {
            [objectsElement addChild:bindingDefinition.element];
        }
    }
}

- (BOOL)element:(NSXMLElement *)element containsObjectWithID:(NSString *)ID {
    NSString *xPath = [NSString stringWithFormat:@"*[@id='%@']", ID];
    NSXMLNode *node = [[element nodesForXPath:xPath
                                       error:nil] firstObject];
    return node ? YES : NO;
}

- (NSXMLElement *)elementWithID:(NSString *)ID {
    NSString *xPath = [NSString stringWithFormat:@"//*[@id='%@']", ID];
    NSXMLElement *node = [[self.xibDocument nodesForXPath:xPath
                                                    error:nil] firstObject];
    return node;
}

- (NSError *)writeXIBSocument {
    NSData* xmlData = [self.xibDocument XMLDataWithOptions:NSXMLNodePrettyPrint];
    if (![xmlData writeToURL:self.xibPathURL atomically:YES]) {
        __block NSString *errorMessage = [NSString stringWithFormat:@"Could not write to file %@", self.xibPathURL];
        return BINDPluginError(BNDPluginErrorWriteErrorCode, errorMessage);
    }
    return nil;
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
        weakSelf.mutableBindings = bindings.mutableCopy;
        
        if (bindingsBlock) {
            bindingsBlock(bindings, error);
        }
    }];
    
    [self reloadBindingOutlets];
}

- (void)reloadBindingOutlets {
    [self.mutablebindingOutlets removeAllObjects];
    
    NSXMLElement *fileOwnerElement = [self elementWithID:@"-1"];
    NSString *xPath = @"connections/outletCollection[@property='bindings']";
    NSArray *outletElements = [fileOwnerElement nodesForXPath:xPath
                                               error:nil];
    for (NSXMLElement *element in outletElements) {
        BNDBindingsOutletDefinition *definition = [BNDBindingsOutletDefinition definitionWithElement:element];
        [self.mutablebindingOutlets addObject:definition];
    }
}

@end
