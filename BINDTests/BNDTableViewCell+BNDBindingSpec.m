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
    
    __block UITableViewCell *cell = nil;
    
    beforeEach(^{
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:@"Cell"];
    });
    
//    context(@"Given a table view cell", ^{
//        it(@"Should fire onTouchUpInside event when highlighted", ^{
//            [[cell should] receive:@selector(setOnTouchUpInside:)];
//            
//            [cell handleSpecialKeyPath:BNDBindingTouchUpInsideKeyPath];            
//            cell.highlighted = YES;
//        });
//    });
});

SPEC_END
