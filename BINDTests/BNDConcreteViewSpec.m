//
//  BNDConcreteViewSpec.m
//  BIND
//
//  Created by Marko Hlebar on 30/11/2014.
//  Copyright 2014 Marko Hlebar. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "BNDConcreteView.h"
#import "BNDBinding.h"
#import "BNDTestObjects.h"

SPEC_BEGIN(BNDConcreteViewSpec)

describe(@"BNDTableViewCell", ^{
    
    __block TableViewCell *cell = nil;
    
    NSArray* (^createBindings)(NSArray *) = ^NSArray*(NSArray *BINDs) {
        NSMutableArray *bindings = [NSMutableArray new];
        for(NSString *BIND in BINDs) {
            BNDBinding *binding = [BNDBinding bindingWithBIND:BIND];
            [bindings addObject:binding];
        }
        return bindings.copy;
    };

    beforeEach(^{
        cell = [[TableViewCell alloc] init];
    });
    
    afterEach(^{
        cell = nil;
    });
    
    context(@"when using a BNDTableViewCell", ^{
        it(@"should bind on view model update", ^{
            cell.bindings = createBindings(@[
                                             @"viewModel.text -> textLabel.text",
                                             @"textLabel.text <- viewModel.text"
                                             ]);
            
            BNDBinding *binding = cell.bindings[0];
            [[binding should] receive:@selector(bindLeft:withRight:)
                        withArguments:cell, cell, nil];
            
            binding = cell.bindings[1];
            [[binding should] receive:@selector(bindLeft:withRight:)
                        withArguments:cell, cell, nil];
            
            ViewModel *viewModel = [ViewModel new];
            cell.viewModel = viewModel;
        });
    });
    
    context(@"when using a BNDTableViewCell", ^{
        it(@"should shorthand bind on view model update", ^{
            cell.bindings = createBindings(@[
                                             @"text -> textLabel.text"
                                             ]);
            
            ViewModel *viewModel = [ViewModel new];
            BNDBinding *binding = cell.bindings[0];
            [[binding should] receive:@selector(bindLeft:withRight:)
                        withArguments:viewModel, cell, nil];
            
            cell.viewModel = viewModel;
        });
    });
});

SPEC_END
