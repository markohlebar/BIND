//
//  BNDBindingDefinitionSpec.m
//  BINDPlugin
//
//  Created by Marko Hlebar on 23/11/2014.
//  Copyright 2014 Marko Hlebar. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "BNDBindingDefinition.h"
#import <Foundation/Foundation.h>


SPEC_BEGIN(BNDBindingDefinitionSpec)

describe(@"BNDBindingDefinition", ^{
    __block BNDBindingDefinition *definition = nil;
    
    NSXMLElement* (^createElement)(NSString *, NSString *) =
    ^ NSXMLElement* (NSString *ID, NSString *BIND) {
        NSString *format = [NSString stringWithFormat:BNDBindingDefinitionXMLTemplate, ID, BIND];
        NSError *error = nil;
        NSXMLDocument *document = [[NSXMLDocument alloc] initWithXMLString:format
                                                                   options:NSXMLNodePreserveAll
                                                                     error:&error];
        return document.rootElement;
    };
    
    context(@"when creating from element", ^{
        it(@"should parse it's ID and BIND", ^{
            NSXMLElement *element = createElement(@"1337", @"input");
            definition = [BNDBindingDefinition definitionWithElement:element];
            [[definition.ID should] equal:@"1337"];
            [[definition.BIND should] equal:@"input"];
        });
    });
    
    context(@"when creating from id and bind", ^{
        it(@"should serialize back to element", ^{
            definition = [BNDBindingDefinition definitionWithID:@"1337"
                                                           BIND:@"input"];
            definition = [BNDBindingDefinition definitionWithElement:definition.element];
            [[definition.ID should] equal:@"1337"];
            [[definition.BIND should] equal:@"input"];
        });
    });
});

SPEC_END
