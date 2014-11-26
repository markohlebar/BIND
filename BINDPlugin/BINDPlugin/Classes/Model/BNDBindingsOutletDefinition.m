//
//  BNDBindingsOutletDefinition.m
//  BINDPlugin
//
//  Created by Marko Hlebar on 25/11/2014.
//  Copyright (c) 2014 Marko Hlebar. All rights reserved.
//

#import "BNDBindingsOutletDefinition.h"

NSString * const BNDBindingsOutletDefinitionXMLTemplate = @"\
<outletCollection property=\"bindings\" destination=\"%@\" id=\"%@\"/>";

@interface BNDBindingsOutletDefinition ()
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *bindingID;
@property (nonatomic) NSXMLElement *element;
@end

@implementation BNDBindingsOutletDefinition

+ (instancetype)definitionWithElement:(NSXMLElement *)element {
    return [[self alloc] initWithElement:element];
}

+ (instancetype)definitionWithID:(NSString *)ID
                       bindingID:(NSString *)bindingID {
    return [[self alloc] initWithID:ID bindingID:bindingID];
}

- (instancetype)initWithElement:(NSXMLElement *)element {
    self = [super init];
    if (self) {
        NSXMLNode *valueNode = [element attributeForName:@"id"];
        _ID = [valueNode stringValue].copy;
        
        valueNode = [element attributeForName:@"destination"];
        _bindingID = [valueNode stringValue].copy;
    }
    return self;
}

- (instancetype)initWithID:(NSString *)ID
                 bindingID:(NSString *)bindingID {
    self = [super init];
    if (self) {
        _ID = ID.copy;
        _bindingID = bindingID.copy;
    }
    return self;
}

- (NSXMLElement *)element {
    if (!_element) {
        NSString *format = [NSString stringWithFormat:BNDBindingsOutletDefinitionXMLTemplate, self.bindingID, self.ID];
        NSXMLDocument *document = [[NSXMLDocument alloc] initWithXMLString:format
                                                                   options:0
                                                                     error:nil];
        _element = document.rootElement;
    }
    return _element.copy;
}

- (BOOL) isEqual:(BNDBindingsOutletDefinition *)object {
    if (self == object || [self.ID isEqualToString:object.ID]) {
        return YES;
    }
    return NO;
}

- (NSUInteger)hash {
    return self.ID.hash;
}


@end
