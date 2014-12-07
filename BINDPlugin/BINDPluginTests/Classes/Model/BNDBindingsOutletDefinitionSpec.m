//
//  BNDBindingsOutletDefinitionSpec.m
//  BINDPlugin
//
//  Created by Marko Hlebar on 25/11/2014.
//  Copyright 2014 Marko Hlebar. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "BNDBindingsOutletDefinition.h"


SPEC_BEGIN(BNDBindingsOutletDefinitionSpec)

describe(@"BNDBindingsOutletDefinition", ^{
    __block BNDBindingsOutletDefinition *definition = nil;
    
    NSXMLElement* (^createElement)(NSString *, NSString *) =
    ^ NSXMLElement* (NSString *ID, NSString *bindingID) {
        NSString *format = [NSString stringWithFormat:BNDBindingsOutletDefinitionXMLTemplate, bindingID, ID];
        NSError *error = nil;
        NSXMLDocument *document = [[NSXMLDocument alloc] initWithXMLString:format
                                                                   options:NSXMLNodePreserveAll
                                                                     error:&error];
        return document.rootElement;
    };
    
    context(@"when created from an element", ^{
        it(@"should parse it's ID and bindingID", ^{
            NSXMLElement *element = createElement(@"1337", @"7331");
            definition = [BNDBindingsOutletDefinition definitionWithElement:element];
            [[definition.ID should] equal:@"1337"];
            [[definition.bindingID should] equal:@"7331"];
        });
    });
    
    context(@"when creating from id and binding id", ^{
        it(@"should serialize back to element", ^{
            definition = [BNDBindingsOutletDefinition definitionWithID:@"1337"
                                                      bindingID:@"7331"];
            definition = [BNDBindingsOutletDefinition definitionWithElement:definition.element];
            [[definition.ID should] equal:@"1337"];
            [[definition.bindingID should] equal:@"7331"];
        });
    });
});

SPEC_END
