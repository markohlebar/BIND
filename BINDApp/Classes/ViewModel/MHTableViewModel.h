//
//  MHColorViewModel.h
//  MVVM
//
//  Created by Marko Hlebar on 25/10/2014.
//  Copyright (c) 2014 Marko Hlebar. All rights reserved.
//

#import "BNDConcreteViewModel.h"

@interface MHTableViewModel : BNDViewModel <BNDTableViewModel>
+ (instancetype)tableViewModelWithRows:(NSArray *)rows;
@end

@interface MHTableSectionViewModel : BNDViewModel <BNDTableSectionViewModel>
- (void)setRows:(NSArray *)rows;
@end
