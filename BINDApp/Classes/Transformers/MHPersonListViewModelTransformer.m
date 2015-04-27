//
//  MHPersonListViewModelTransformer.m
//  BIND
//
//  Created by Marko Hlebar on 26/04/2015.
//  Copyright (c) 2015 Marko Hlebar. All rights reserved.
//

#import "MHPersonListViewModelTransformer.h"
#import "MHPerson.h"
#import "BNDTableSectionViewModel.h"
#import "MHPersonNameViewModel.h"

@implementation MHPersonListViewModelTransformer

- (id)transformedValue:(NSArray *)personae {
    BNDTableSectionViewModel *section = [BNDTableSectionViewModel new];
    for (MHPerson *person in personae) {
        id viewModel = [MHPersonNameViewModel viewModelWithModel:person];
        [section addSubViewModel:viewModel];
    }
    return @[section];
}

@end
