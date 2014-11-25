//
//  BNDInterfaceBuilderWriterSpec.m
//  BINDPlugin
//
//  Created by Marko Hlebar on 23/11/2014.
//  Copyright 2014 Marko Hlebar. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "BNDInterfaceBuilderWriter.h"
#import "BNDBindingDefinition.h"


SPEC_BEGIN(BNDInterfaceBuilderWriterSpec)

describe(@"BNDInterfaceBuilderWriter", ^{
    __block BNDInterfaceBuilderWriter *writer = nil;
    __block NSArray *_bindings = nil;
    __block NSError *_error = nil;
    
    BNDInterfaceBuilderWriter* (^writerWithXIBNamed)(NSString *) = ^BNDInterfaceBuilderWriter*(NSString *xibName) {
        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        NSURL *pathURL = [bundle URLForResource:xibName
                                  withExtension:@"xib"];
        return [BNDInterfaceBuilderWriter writerWithXIBPathURL:pathURL];
    };
    
    void (^addBinding)(NSString *) = ^void(NSString *ID){
        BNDBindingDefinition *definition = [BNDBindingDefinition definitionWithID:ID
                                                                             BIND:@"test"];
        [writer addBinding:definition];
    };
    
    beforeEach(^{
        writer = writerWithXIBNamed(@"ViewControllerWithBinding");
        [writer reloadBindings:^(NSArray *bindings, NSError *error) {
            _bindings = bindings;
            _error = error;
        }];
    });
    
    specify(^{
        [[_bindings should] haveCountOf:1];
        [[_error should] beNil];
    });
    
    context(@"when adding a binding", ^{
        it(@"should increase the number of bindings", ^{
            addBinding(@"ID");
            [[writer.bindings should] haveCountOf:2];
        });
        
        it(@"should not increase the number of bindings if adding the the same binding", ^{
            addBinding(@"SwF-v5-LSL");
            [[writer.bindings should] haveCountOf:1];
        });
    });
    
    context(@"when removing a binding", ^{
        it(@"should increase the number of bindings", ^{
            BNDBindingDefinition *definition = [BNDBindingDefinition definitionWithID:@"SwF-v5-LSL"
                                                                                 BIND:@"test"];
            [writer removeBinding:definition];
            [[writer.bindings should] haveCountOf:0];
        });
    });

    context(@"when removing all bindings", ^{
        it(@"bindings count should be 0", ^{
            [writer removeAllBindings];
            [[writer.bindings should] haveCountOf:0];
        });
    });
    
    context(@"when writing bindings", ^{
        it(@"should write bindings to the same file URL", ^{
            [writer write:nil];
            BNDInterfaceBuilderWriter *writer2 = writerWithXIBNamed(@"ViewControllerWithBinding");
            [writer2 reloadBindings:nil];
            [[writer.bindings should] equal:writer2.bindings];
        });
    });
    
    context(@"when writing bindings after adding bindings", ^{
        it(@"should write bindings to the same file URL", ^{
            addBinding(@"ID");
            [writer write:nil];
            BNDInterfaceBuilderWriter *writer2 = writerWithXIBNamed(@"ViewControllerWithBinding");
            [writer2 reloadBindings:nil];
            [[writer.bindings should] equal:writer2.bindings];
        });
    });
});

SPEC_END
