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

+ (instancetype)parserWithXIBDocument:(NSXMLDocument *)xibDocument; {
    NSAssert(xibDocument, @"xibDocument should not be nil");
    return [[self alloc] initWithXIBDocument:xibDocument];
}

- (instancetype)initWithXIBDocument:(NSXMLDocument *)xibDocument {
    self = [super init];
    if (self) {
        _xibDocument = xibDocument;
    }
    return self;
}

- (void)parse:(BNDBindingsBlock)bindingsBlock {
    self.bindingsBlock = bindingsBlock;
    [self parseDocument:self.xibDocument];
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

- (void)reportNoBindingsError {
    NSError *error = BINDPluginError(BNDPluginErrorMissingBindingsErrorCode, @"No bindings outlet in file's owner. Please create a BNDBinding collection outlet array.");
    self.bindingsBlock(nil, error);
}

@end
