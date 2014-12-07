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
#import "BNDBindingDefinitionFactory.h"

static NSString * const BNDObjectsXpath = @"document/objects";
static NSString * const BNDFileOwnerConnectionsXpath = @"document/objects/placeholder[@placeholderIdentifier='IBFilesOwner']/connections";

@interface BNDInterfaceBuilderWriter ()
@property (nonatomic, strong) BNDInterfaceBuilderParser *parser;
@property (nonatomic, strong) BNDBindingDefinitionFactory *definitionFactory;
@property (nonatomic, strong) NSMutableArray *mutableBindings;
@property (nonatomic, strong) NSMutableArray *mutableBindingOutlets;
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
        _mutableBindingOutlets = [NSMutableArray new];        
    }
    return self;
}

- (NSArray *)bindings {
    return self.mutableBindings.copy;
}

- (NSArray *)bindingOutlets {
    return self.mutableBindingOutlets.copy;
}

- (void)createBinding {
    BNDBindingDefinition *definition = [self.definitionFactory createBinding];
    [self addBinding:definition];
}

- (void)addBinding:(BNDBindingDefinition *)binding {
    if (![self.mutableBindings containsObject:binding]) {
        [self.mutableBindings addObject:binding];
        
        BNDBindingsOutletDefinition *outlet = [self.definitionFactory createBindingOutletWithBinding:binding];

        if (![self.mutableBindingOutlets containsObject:outlet]) {
            [self.mutableBindingOutlets addObject:outlet];
        }
    }
    
    [self notifyDelegate];
}

- (void)removeBinding:(BNDBindingDefinition *)binding {
    [self.mutableBindings removeObject:binding];
    
    BNDBindingsOutletDefinition *outlet = [self outletForBinding:binding];
    [self.mutableBindingOutlets removeObject:outlet];
    
    [self notifyDelegate];
}

- (BNDBindingsOutletDefinition *)outletForBinding:(BNDBindingDefinition *)binding {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"bindingID == %@", binding.ID];
    NSArray *outlets = [self.bindingOutlets filteredArrayUsingPredicate:predicate];
    return [outlets firstObject];
}

- (void)removeAllBindings {
    [self.mutableBindings removeAllObjects];
    [self.mutableBindingOutlets removeAllObjects];
    
    [self notifyDelegate];
}

- (void)write:(BNDErrorBlock)errorBlock {
    [self addBindingsToObjectsElement];
    [self addBindingOutletsToFileOwnerConnectionsElement];
    
    NSError *error = [self writeXIBSocument];
    if (errorBlock) {
        errorBlock(error);
    }
}

- (void)addBindingsToObjectsElement {
    NSXMLElement *objectsElement = [self objectsElement];
    
    for (BNDBindingDefinition *bindingDefinition in self.mutableBindings) {
        if (![self element:objectsElement containsObjectWithID:bindingDefinition.ID]) {
            [objectsElement addChild:bindingDefinition.element];
        }
    }
}

- (void)addBindingOutletsToFileOwnerConnectionsElement {
    NSXMLElement *connectionsElement = [self fileOwnerConnectionsElement];
    
    for (BNDBindingsOutletDefinition *outlet in self.mutableBindingOutlets) {
        if (![self element:connectionsElement containsObjectWithID:outlet.ID]) {
            [connectionsElement addChild:outlet.element];
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
    NSArray *objects = [self.xibDocument nodesForXPath:BNDObjectsXpath
                                                 error:nil];
    return [objects firstObject];
}

- (NSXMLElement *)fileOwnerConnectionsElement {
    NSArray *connections = [self.xibDocument nodesForXPath:BNDFileOwnerConnectionsXpath
                                                     error:nil];
    return [connections firstObject];
}

- (NSXMLDocument *)openXIBDocument:(NSError **) error{
    self.xibDocument = [[NSXMLDocument alloc] initWithContentsOfURL:self.xibPathURL
                                                            options:NSXMLNodePreserveAll
                                                              error:error];
    return self.xibDocument;
}

- (NSArray *)reloadBindings:(NSError **)reloadError {
    NSError *error = nil;
    NSXMLDocument *document = [self openXIBDocument:&error];
    if (error && reloadError) {
        *reloadError = error;
        return nil;
    }
    
    __block NSError *parseError = nil;
    self.parser = [BNDInterfaceBuilderParser parserWithXIBDocument:document];
    __weak typeof(self) weakSelf = self;
    [self.parser parse:^(NSArray *bindings, NSError *error) {
        weakSelf.mutableBindings = bindings.mutableCopy;
        parseError = error;
    }];
    
    if (parseError && reloadError) {
        *reloadError = parseError;
    }
    
    self.definitionFactory = [BNDBindingDefinitionFactory factoryWithBindings:self.bindings];
    [self reloadBindingOutlets];
    
    return self.bindings;
}

- (void)reloadBindingOutlets {
    [self.mutableBindingOutlets removeAllObjects];
    
    NSXMLElement *fileOwnerElement = [self elementWithID:@"-1"];
    NSString *xPath = @"connections/outletCollection[@property='bindings']";
    NSArray *outletElements = [fileOwnerElement nodesForXPath:xPath
                                               error:nil];
    for (NSXMLElement *element in outletElements) {
        BNDBindingsOutletDefinition *definition = [BNDBindingsOutletDefinition definitionWithElement:element];
        [self.mutableBindingOutlets addObject:definition];
    }
}


- (void)notifyDelegate {
    [self.delegate writer:self
    didUpdateWithBindings:self.bindings];
}

@end
