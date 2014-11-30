//
//  NSTableView+BNDBindingSpec.m
//  BIND
//
//  Created by Marko Hlebar on 30/11/2014.
//  Copyright 2014 Marko Hlebar. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "NSTableView+BNDBinding.h"

SPEC_BEGIN(NSTableView_BNDBindingSpec)

describe(@"NSTableView+BNDBinding", ^{
    __block NSTableView *tableView = nil;
    
    beforeEach(^{
        tableView = [[NSTableView alloc] initWithFrame:NSMakeRect(0, 0, 100, 200)];
    });
    
    context(@"when a NSTextView is created", ^{
        it(@"should be KVO compliant ", ^{
            NSTableView *returnTableView = [tableView valueForKey:@"onReloadData"];
            [[returnTableView should] equal:tableView];
            
            [[tableView should] receive:@selector(reloadData)];
            [tableView setValue:tableView forKey:@"onReloadData"];
        });
    });
});

SPEC_END
