//
//  BNDBindingDefinition.m
//  BINDPlugin
//
//  Created by Marko Hlebar on 23/11/2014.
//  Copyright (c) 2014 Marko Hlebar. All rights reserved.
//

#import "BNDBindingDefinition.h"

NSString *const BNDBindingDefinitionXMLTemplate = @"\
<customObject id=\"%@\" customClass=\"BNDBinding\">\
<userDefinedRuntimeAttributes>\
<userDefinedRuntimeAttribute type=\"string\" keyPath=\"BIND\" value=\"%@\"/>\
</userDefinedRuntimeAttributes>\
</customObject>";

@interface BNDBindingDefinition ()
@property (nonatomic, copy) NSString *ID;
@property (nonatomic) NSXMLElement *element;
@end

@implementation BNDBindingDefinition

+ (instancetype)definitionWithElement:(NSXMLElement *)element {
    return [[self alloc] initWithElement:element];
}

+ (instancetype)definitionWithID:(NSString *)ID
                            BIND:(NSString *)BIND {
    BNDBindingDefinition *definition = BNDBindingDefinition.new;
    definition.ID = ID;
    definition.BIND = BIND;
    return definition;
}

- (instancetype)initWithElement:(NSXMLElement *)element {
    self = [super init];
    if (self) {
        _element = element;
        
        NSXMLNode *valueNode = [element attributeForName:@"id"];
        _ID = [valueNode stringValue].copy;
        
        NSXMLElement *attributesElement = [[element elementsForName:@"userDefinedRuntimeAttributes"] firstObject];
        NSXMLElement *attributeElement = [[attributesElement elementsForName:@"userDefinedRuntimeAttribute"] firstObject];
        
//        Xpath fails when I create my own hierarchy ??
//        NSXMLElement *attributesElement = [[element nodesForXPath:@"//userDefinedRuntimeAttribute"
//                                                            error:nil] firstObject];
        valueNode = [attributeElement attributeForName:@"value"];
        _BIND = [valueNode stringValue].copy;
    }
    return self;
}

- (NSXMLElement *)element {
    if (!_element) {
        NSString *format = [NSString stringWithFormat:BNDBindingDefinitionXMLTemplate, self.ID, self.BIND];
        NSXMLDocument *document = [[NSXMLDocument alloc] initWithXMLString:format
                                                                   options:0
                                                                     error:nil];
        _element = document.rootElement;
    }
    return _element.copy;
}

- (BOOL)isEqual:(BNDBindingDefinition *)object {
    if (self == object || [self.ID isEqualToString:object.ID]) {
        return YES;
    }
    return NO;
}

- (NSUInteger)hash {
    return self.ID.hash;
}

@end
