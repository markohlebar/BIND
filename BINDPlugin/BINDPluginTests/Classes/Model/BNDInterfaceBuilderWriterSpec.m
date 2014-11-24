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
    
    BNDInterfaceBuilderWriter* (^writerWithXIBNamed)(NSString *) = ^BNDInterfaceBuilderWriter*(NSString *xibName) {
        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        NSURL *pathURL = [bundle URLForResource:xibName
                                  withExtension:@"xib"];
        return [BNDInterfaceBuilderWriter writerWithXIBPathURL:pathURL];
    };
    
    beforeEach(^{
        writer = writerWithXIBNamed(@"ViewController");
    });
    
    context(@"when adding a binding", ^{
        it(@"should increase the number of bindings", ^{
            BNDBindingDefinition *definition = [BNDBindingDefinition definitionWithID:@"ID"
                                                                                 BIND:@"test"];
            [writer addBinding:definition];
            [[writer.bindings should] haveCountOf:1];
        });
    });
});

SPEC_END
