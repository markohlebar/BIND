//
//  BNDInterfaceBuilderParserSpec.m
//  BINDPlugin
//
//  Created by Marko Hlebar on 23/11/2014.
//  Copyright 2014 Marko Hlebar. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "BNDInterfaceBuilderParser.h"
#import "BNDPluginErrors.h"

SPEC_BEGIN(BNDInterfaceBuilderParserSpec)

describe(@"BNDInterfaceBuilderParser", ^{
    __block NSArray *_bindings = nil;
    __block NSError *_error = nil;
    __block BNDInterfaceBuilderParser *parser = nil;
    
    BNDInterfaceBuilderParser* (^parserWithXIBNamed)(NSString *) = ^BNDInterfaceBuilderParser*(NSString *xibName) {
        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        NSURL *pathURL = [bundle URLForResource:xibName
                                  withExtension:@"xib"];
        
        NSXMLDocument *xibDocument = [[NSXMLDocument alloc] initWithContentsOfURL:pathURL
                                                                          options:NSXMLNodePreserveAll
                                                                            error:nil];
        
        return [BNDInterfaceBuilderParser parserWithXIBDocument:xibDocument];
    };
    
    context(@"when a xib file has a file owner that has no bindings", ^{
        it(@"should return an array with 0 bindings", ^{
            parser = parserWithXIBNamed(@"Empty");
            [parser parse:^(NSArray *bindings, NSError *error) {
                _bindings = bindings;
                _error = error;
            }];
            
            [[_error should] beNil];
            [[_bindings should] haveCountOf:0];
        });
    });
    
    context(@"when a xib file has a suitable file owner", ^{
        it(@"should return a correct number of bindings", ^{
            parser = parserWithXIBNamed(@"ViewControllerWithBinding");
            [parser parse:^(NSArray *bindings, NSError *error) {
                _bindings = bindings;
                _error = error;
            }];
            
            [[_error should] beNil];
            [[_bindings should] haveCountOf:1];
        });
    });
    
    
});

SPEC_END
