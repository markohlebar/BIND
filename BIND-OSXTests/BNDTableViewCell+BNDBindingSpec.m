//
//  BNDTableViewCell+BNDBindingSpec.m
//  BIND
//
//  Created by Marko Hlebar on 06/12/2014.
//  Copyright 2014 Marko Hlebar. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "BNDTableViewCell+BNDBinding.h"


SPEC_BEGIN(BNDTableViewCell_BNDBindingSpec)

describe(@"BNDTableViewCell+BNDBinding", ^{

    __block NSTableCellView *cell = nil;
    
    beforeEach(^{
        cell = [[NSTableCellView alloc] init];
    });
    
    context(@"Given a table view cell", ^{
        it(@"Should fire onTouchUpInside event when highlighted", ^{
            [[cell should] receive:@selector(setOnTouchUpInside:)];
            
            [cell handleSpecialKeyPath:BNDBindingTouchUpInsideKeyPath];
            cell.backgroundStyle = NSBackgroundStyleDark;
        });
    });
});

SPEC_END
