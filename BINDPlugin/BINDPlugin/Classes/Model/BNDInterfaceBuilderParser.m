//
//  BNDInterfaceBuilderParser.m
//  BINDPlugin
//
//  Created by Marko Hlebar on 23/11/2014.
//  Copyright (c) 2014 Marko Hlebar. All rights reserved.
//

#import "BNDInterfaceBuilderParser.h"
#import "BNDPluginErrors.h"
#import <Foundation/NSXMLDocument.h>
#import <Foundation/NSXMLNode.h>
#import "BNDBindingDefinition.h"

static NSString * const BNDBindingXpath = @"document/objects/customObject[@customClass='BNDBinding']";

@interface BNDInterfaceBuilderParser ()
@property (nonatomic, strong) NSXMLDocument *xibDocument;
@property (nonatomic, copy) BNDBindingsBlock bindingsBlock;
@end

@implementation BNDInterfaceBuilderParser

+ (instancetype)parserWithXIBPathURL:(NSURL *)xibPathURL {
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

- (void)parse:(BNDBindingsBlock)bindingsBlock {
    self.bindingsBlock = bindingsBlock;
    
    NSXMLDocument *document = [self openXIBDocument];
    if (document) {
        [self parseDocument:document];
    }
}

- (void)parseDocument:(NSXMLDocument *)document {
    NSError *error = nil;
    NSArray *bindingElements = [document nodesForXPath:BNDBindingXpath
                                                 error:&error];
    if (!error) {
        NSArray *bindings = [self bindingsForElements:bindingElements];
        self.bindingsBlock(bindings, nil);
    }
    else {
        self.bindingsBlock(nil, error);
    }
}

- (NSArray *)bindingsForElements:(NSArray *)elements {
    NSMutableArray *bindings = NSMutableArray.new;
    for (NSXMLElement *element in elements) {
        BNDBindingDefinition *binding = [BNDBindingDefinition definitionWithElement:element];
        [bindings addObject:binding];
    }
    return bindings.copy;
}

- (NSXMLDocument *)openXIBDocument {
    NSError *error = nil;

    self.xibDocument = [[NSXMLDocument alloc] initWithContentsOfURL:self.xibPathURL
                                                            options:NSXMLNodePreserveAll
                                                              error:&error];
    if (error) {
        self.bindingsBlock(nil, error);
        return nil;
    }
    
    return self.xibDocument;
}

- (void)reportNoBindingsError {
    NSError *error = BINDPluginError(BNDPluginErrorMissingBindingsErrorCode, @"No bindings outlet in file's owner. Please create a BNDBinding collection outlet array.");
    self.bindingsBlock(nil, error);
}

@end
