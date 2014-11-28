//
//  BNDBindingDefinitionFactorySpec.m
//  BINDPlugin
//
//  Created by Marko Hlebar on 28/11/2014.
//  Copyright 2014 Marko Hlebar. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "BNDBindingDefinitionFactory.h"
#import "BNDBindingDefinition.h"


SPEC_BEGIN(BNDBindingDefinitionFactorySpec)

describe(@"BNDBindingDefinitionFactory", ^{
    
    __block BNDBindingDefinitionFactory *factory = nil;
    
    NSArray* (^createBindings)(NSInteger numBindings) = ^NSArray*(NSInteger numBindings) {
        NSMutableArray *bindings = [NSMutableArray array];
        for(NSInteger i = 0; i < numBindings; i++) {
            NSString *ID = [NSString stringWithFormat:BNDBindingIDFormat, i];
            BNDBindingDefinition *definition = [BNDBindingDefinition definitionWithID:ID
                                                                                 BIND:@""];
            [bindings addObject:definition];
        }
        return bindings.copy;
    };
    
    context(@"when bindings are empty", ^{
        it(@"should create a binding and add it to the array", ^{
            factory = [BNDBindingDefinitionFactory factoryWithBindings:[NSArray new]];
            
            BNDBindingDefinition *binding = [factory createBinding];
            [[factory.bindings should] haveCountOf:1];
            [[binding.ID should] equal:[NSString stringWithFormat:BNDBindingIDFormat, 0]];
            
            binding = [factory createBinding];
            [[factory.bindings should] haveCountOf:2];
            [[binding.ID should] equal:[NSString stringWithFormat:BNDBindingIDFormat, 1]];
        });
    });
    
    context(@"when bindings are not empty", ^{
        it(@"should create binding with unique ID and add it to the array", ^{
            factory = [BNDBindingDefinitionFactory factoryWithBindings:createBindings(5)];
            
            BNDBindingDefinition *binding = [factory createBinding];
            [[factory.bindings should] haveCountOf:6];
            [[binding.ID should] equal:[NSString stringWithFormat:BNDBindingIDFormat, 5]];
            
            binding = [factory createBinding];
            [[factory.bindings should] haveCountOf:7];
            [[binding.ID should] equal:[NSString stringWithFormat:BNDBindingIDFormat, 6]];
        });
        
        it(@"should create a binding outlet definition", ^{
            factory = [BNDBindingDefinitionFactory factoryWithBindings:createBindings(5)];

            BNDBindingDefinition *binding = [factory createBinding];
            BNDBindingsOutletDefinition *outlet = [factory createBindingOutletWithBinding:binding];
            [[outlet.ID should] equal:[NSString stringWithFormat:BNDBindingOutletIDFormat, 5]];
            [[outlet.bindingID should] equal:binding.ID];
        });
    });
});

SPEC_END
