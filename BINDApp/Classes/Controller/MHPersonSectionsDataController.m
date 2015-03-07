//
//  MHPersonSectionsDataController.m
//  MVVM
//
//  Created by Marko Hlebar on 02/11/2014.
//  Copyright (c) 2014 Marko Hlebar. All rights reserved.
//

#import "MHPersonSectionsDataController.h"
#import "MHPerson.h"
#import "MHPersonSectionViewModel.h"
#import "MHPersonNameViewModel.h"

@implementation MHPersonSectionsDataController

- (NSArray *)viewModelsForPersonae:(NSArray *)personae {
    NSMutableArray *viewModels = [NSMutableArray new];
    
    NSSortDescriptor *nameSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"fullName"
                                                                         ascending:YES];
    personae = [personae sortedArrayUsingDescriptors:@[nameSortDescriptor]];
    NSArray *firstLetters = [self firstLettersForPersonae:personae];
    
    for (NSString *firstLetter in firstLetters) {
        NSPredicate *firstLetterPredicate = [NSPredicate predicateWithFormat:@"fullName BEGINSWITH %@", firstLetter];
        NSArray *matchingPersons = [personae filteredArrayUsingPredicate:firstLetterPredicate];
        NSMutableArray *rowViewModels = NSMutableArray.new;
        for (MHPerson *person in matchingPersons) {
            MHPersonNameViewModel *viewModel = [MHPersonNameViewModel viewModelWithModel:person];
            [rowViewModels addObject:viewModel];
        }
        
        MHPersonSectionViewModel *section = [MHPersonSectionViewModel viewModelWithModel:rowViewModels.copy];
        section.title = firstLetter;
        [viewModels addObject:section];
    }
    
    return viewModels.copy;
}

- (NSArray *)firstLettersForPersonae:(NSArray *)personae {
    NSMutableArray *letters = NSMutableArray.new;
    for (MHPerson *person in personae) {
        NSString *firstLetter = [person.fullName substringToIndex:1];
        if (![letters containsObject:firstLetter]) {
            [letters addObject:firstLetter];
        }
    }
    
    [letters sortUsingSelector:@selector(compare:)];
    return letters.copy;
}

@end
