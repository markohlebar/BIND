//
//  MHColorViewModel.m
//  BIND
//
//  Created by Marko Hlebar on 19/03/2015.
//  Copyright (c) 2015 Marko Hlebar. All rights reserved.
//

#import "MHTableViewModel.h"

@implementation MHTableViewModel

- (NSArray *)sectionViewModels {
    return self.children;
}

+ (instancetype)tableViewModelWithRows:(NSArray *)rows {
    MHTableViewModel *tableViewModel = [MHTableViewModel viewModelWithModel:nil];
    MHTableSectionViewModel *sectionViewModel = [MHTableSectionViewModel viewModelWithModel:nil];
    [tableViewModel addChild:sectionViewModel];
    [sectionViewModel setRows:rows];
    return tableViewModel;
}

@end


@implementation MHTableSectionViewModel

- (void)setRows:(NSArray *)rows {
    for (id <BNDTableRowViewModel> row in rows) {
        [self addChild:row];
    }
}

- (NSArray *)rowViewModels {
    return self.children;
}

- (CGFloat)cellHeight {
    return 0;
}

@end