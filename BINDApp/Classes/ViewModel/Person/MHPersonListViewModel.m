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

@implementation MHPersonListViewModel
BINDINGS(MHPersonCreator,
         BINDModelT(personae, ~>, children, MHPersonListViewModelTransformer),
         nil)

- (id <BNDCommand> )createPersonCommand {
    if (!_createPersonCommand) {
        _createPersonCommand = [MHAddPersonCommand commandWithCreator:self.model];
    }
    return _createPersonCommand;
}

@end
