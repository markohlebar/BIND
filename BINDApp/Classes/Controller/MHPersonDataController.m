//
//  MHTableDataController.m
//  MVVM
//
//  Created by Marko Hlebar on 25/10/2014.
//  Copyright (c) 2014 Marko Hlebar. All rights reserved.
//

#import "MHPersonDataController.h"
#import "MHPersonFetcher.h"
#import "MHPerson.h"
#import "MHPersonNameViewModel.h"
#import "MHPersonColorViewModel.h"

@implementation MHPersonDataController

- (instancetype)init {
    self = [super init];
    if (self) {
        _dataFetcher = [MHPersonFetcher new];
    }
    return self;
}

- (void)updateWithContext:(id)context
        viewModelsHandler:(BNDViewModelsBlock)viewModelsHandler {
    __weak typeof(self) weakSelf = self;
    [self.dataFetcher fetchPersonae:^(NSArray *personae) {
        NSArray *viewModels = [weakSelf viewModelsForPersonae:personae];
        viewModelsHandler(viewModels, nil);
    }];
}

- (NSArray *)viewModelsForPersonae:(NSArray *)personae {
    NSMutableArray *viewModels = [NSMutableArray new];
    for (MHPerson *person in personae) {
        Class viewModelClass = (person.ID.integerValue % 2 == 0) ?
        [MHPersonNameViewModel class] :
        [MHPersonColorViewModel class];
        
        id viewModel = [viewModelClass viewModelWithModel:person];
        [viewModels addObject:viewModel];
    }
    return viewModels.copy;
}

@end
