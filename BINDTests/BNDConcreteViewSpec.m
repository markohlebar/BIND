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

@interface TestTableViewCell : BNDTableViewCell

@end

@implementation TestTableViewCell
BINDINGS(ViewModel,
         BINDViewModel(text, ~>, textLabel.text),
         BINDViewModel(color, ~>, backgroundColor),
         nil)
@end

@interface SubclassTestTableViewCell : TestTableViewCell

@end

@implementation SubclassTestTableViewCell
BINDINGS(ViewModel,
         BINDViewModel(text, ~>, detailTextLabel.text),
         nil)
@end

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
    
    context(@"When using a BNDTableViewCell", ^{
        it(@"Should bind on view model update", ^{
            cell.bindings = createBindings(@[
                                             @"viewModel.text ~> textLabel.text",
                                             @"textLabel.text ~> viewModel.text"
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
    
    context(@"When using a BNDTableViewCell", ^{
        it(@"Should shorthand bind on view model update", ^{
            cell.bindings = createBindings(@[
                                             @"text ~> textLabel.text"
                                             ]);
            
            ViewModel *viewModel = [ViewModel new];
            BNDBinding *binding = cell.bindings[0];
            [[binding should] receive:@selector(bindLeft:withRight:)
                        withArguments:viewModel, cell, nil];
            
            cell.viewModel = viewModel;
        });
    });
    
    context(@"When using a BNDTableViewCell subclass and BINDViewModel", ^{
        it(@"Should bind the view model correctly", ^{
            TestTableViewCell *cell = [TestTableViewCell new];
            ViewModel *viewModel = [ViewModel new];
            viewModel.text = @"TEST";
            viewModel.color = [UIColor redColor];
            cell.viewModel = viewModel;
            
            [[cell.textLabel.text should] equal:@"TEST"];
            [[cell.backgroundColor should] equal:[UIColor redColor]];
        });
    });
    
    context(@"When using a BNDTableViewCell subclass and BINDViewModel", ^{
        it(@"Should keep transform block when assigning view model", ^{
            TestTableViewCell *cell = [TestTableViewCell new];
            ViewModel *viewModel = [ViewModel new];
            
            BNDBinding *binding = [BNDBinding bindingWithBIND:@"text ~> textLabel.text"];
            [binding transform:^id(id object, id value) {
                return [value uppercaseString];
            }];
            cell.bindings = @[binding];
            
            viewModel.text = @"test";
            cell.viewModel = viewModel;
            
            [[cell.textLabel.text should] equal:@"TEST"];
        });
        
        it(@"Should keep value transformer when assigning view model", ^{
            TestTableViewCell *cell = [TestTableViewCell new];
            ViewModel *viewModel = [ViewModel new];
            
            BNDBinding *binding = [BNDBinding bindingWithBIND:@"text ~> textLabel.text | UppercaseStringTransformer"];
            [binding transform:^id(id object, id value) {
                return [value uppercaseString];
            }];
            cell.bindings = @[binding];
            
            viewModel.text = @"test";
            cell.viewModel = viewModel;
            
            [[cell.textLabel.text should] equal:@"TEST"];
        });
    });
    
    context(@"When using a subclass of a subclass of BNDTableViewCell", ^{
        it(@"Should keep the bindings specified in the superclass", ^{
            SubclassTestTableViewCell *cell = [SubclassTestTableViewCell new];
            ViewModel *viewModel = [ViewModel new];
            cell.viewModel = viewModel;
            
            [[cell.bindings should] haveCountOf:3];
        });
    });
});

SPEC_END
