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
#import "MHImportBusterTestsHelper.h"

SPEC_BEGIN(BNDInterfaceBuilderWriterSpec)

describe(@"BNDInterfaceBuilderWriter", ^{
    __block BNDInterfaceBuilderWriter *_writer = nil;
    __block NSArray *_bindings = nil;
    __block NSError *_error = nil;
    
    BNDInterfaceBuilderWriter* (^writerWithXIBNamed)(NSString *) = ^BNDInterfaceBuilderWriter*(NSString *xibName) {
        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        NSURL *pathURL = [bundle URLForResource:xibName
                                  withExtension:@"xib"];
        
        NSString *tempFilePath = createTempFile([pathURL path]);
        NSURL *tempFileURL = [NSURL fileURLWithPath:tempFilePath];

        return [BNDInterfaceBuilderWriter writerWithXIBPathURL:tempFileURL];
    };
    
    void (^addBinding)(NSString *) = ^void(NSString *ID){
        BNDBindingDefinition *definition = [BNDBindingDefinition definitionWithID:ID
                                                                             BIND:@"test"];
        [_writer addBinding:definition];
    };
    
    beforeEach(^{
        _writer = writerWithXIBNamed(@"ViewControllerWithBinding");
        _bindings = [_writer reloadBindings:&_error];
    });
    
    afterEach(^{
        deleteFile(_writer.xibPathURL.path);
    });
    
    specify(^{
        [[_writer.bindingOutlets should] haveCountOf:1];
        [[_bindings should] haveCountOf:1];
        [[_error should] beNil];
    });
    
    context(@"when creatingg a binding", ^{
        it(@"should increase the number of bindings", ^{
            [_writer createBinding];
            [[_writer.bindings should] haveCountOf:2];
            [[_writer.bindingOutlets should] haveCountOf:2];
        });
    });
    
    context(@"when adding a binding", ^{
        it(@"should increase the number of bindings", ^{
            addBinding(@"ID");
            [[_writer.bindings should] haveCountOf:2];
            [[_writer.bindingOutlets should] haveCountOf:2];
        });
        
        it(@"should not increase the number of bindings if adding the the same binding", ^{
            addBinding(@"SwF-v5-LSL");
            [[_writer.bindings should] haveCountOf:1];
            [[_writer.bindingOutlets should] haveCountOf:1];
        });
    });
    
    context(@"when removing a binding", ^{
        it(@"should increase the number of bindings", ^{
            BNDBindingDefinition *definition = [BNDBindingDefinition definitionWithID:@"SwF-v5-LSL"
                                                                                 BIND:@"test"];
            [_writer removeBinding:definition];
            [[_writer.bindings should] haveCountOf:0];
            [[_writer.bindingOutlets should] haveCountOf:0];
        });
    });

    context(@"when removing all bindings", ^{
        it(@"bindings count should be 0", ^{
            [_writer removeAllBindings];
            [[_writer.bindings should] haveCountOf:0];
            [[_writer.bindingOutlets should] haveCountOf:0];
        });
    });
    
    context(@"when writing bindings", ^{
        it(@"should write bindings to the same file URL", ^{
            [_writer write:nil];
            BNDInterfaceBuilderWriter *writer2 = writerWithXIBNamed(@"ViewControllerWithBinding");
            [writer2 reloadBindings:nil];
            [[_writer.bindings should] equal:writer2.bindings];
            [[_writer.bindingOutlets should] equal:writer2.bindingOutlets];
        });
    });
    
    context(@"when writing bindings after adding bindings", ^{
        it(@"should write bindings to the same file URL", ^{
            addBinding(@"ID");
            [_writer write:nil];
            
            BNDInterfaceBuilderWriter *writer2 = [BNDInterfaceBuilderWriter writerWithXIBPathURL:_writer.xibPathURL];
            [writer2 reloadBindings:nil];
            [[_writer.bindings should] equal:writer2.bindings];
            [[_writer.bindingOutlets should] equal:writer2.bindingOutlets];
        });
    });
});

SPEC_END
