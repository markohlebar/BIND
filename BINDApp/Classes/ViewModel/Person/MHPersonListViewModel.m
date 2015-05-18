//
//  MHPersonColorViewModel.m
//  MVVM
//
//  Created by Marko Hlebar on 02/11/2014.
//  Copyright (c) 2014 Marko Hlebar. All rights reserved.
//

#import "MHPersonListViewModel.h"
#import "MHPerson.h"
#import "MHPersonCreator.h"
#import "MHAddPersonCommand.h"
#import "MHPersonListViewModelTransformer.h"
#import "BNDTableSectionViewModel.h"

@implementation MHPersonListViewModel
BINDINGS(MHPersonCreator,
         
         BINDCreateRows(personae, ->, children),
         nil
         );

- (id <BNDCommand> )createPersonCommand {
    if (!_createPersonCommand) {
        _createPersonCommand = [MHAddPersonCommand commandWithCreator:self.model];
    }
    return _createPersonCommand;
}

- (instancetype)initWithModel:(id)model
{
    self = [super initWithModel:model];
    if (self) {
        [self observeModel];
    }
    return self;
}

- (void)observeModel {
    __weak typeof(self) weakSelf = self;
    MHPersonCreator *creator = self.model;
    [BINDO(creator, personae) observe:^(id observable, id value, NSDictionary *observationInfo){
        [weakSelf addRowForObservationInfo:observationInfo];
    }];
}

- (void)addRowForObservationInfo:(NSDictionary *)observationInfo {
    NSIndexSet *indexSet = observationInfo[NSKeyValueChangeIndexesKey];
    MHPerson *model = observationInfo[NSKeyValueChangeNewKey];
    NSKeyValueChange kind = [observationInfo[NSKeyValueChangeKindKey] integerValue];
    
    switch (kind) {
        case NSKeyValueChangeInsertion:

            break;
        case NSKeyValueChangeRemoval:
 
            break;

        default:
            break;
    }
                             
}

- (BNDTableSectionViewModel *)sectionViewModel {
    BNDTableSectionViewModel *section = [self.subViewModels firstObject];
    if (!section) {
        section = [BNDTableSectionViewModel viewModelWithModel:nil];
        [self addSubViewModel:section];
    }
    return section;
}

@end
