//
//  MHPersonColorViewModel.m
//  MVVM
//
//  Created by Marko Hlebar on 02/11/2014.
//  Copyright (c) 2014 Marko Hlebar. All rights reserved.
//

#import "MHPersonColorViewModel.h"
#import "MHPerson.h"
#import "MHPersonCreator.h"
#import "MHAddPersonCommand.h"

@implementation MHPersonColorViewModel
BINDINGS(MHPersonCreator,
         BINDProperty(personae, ~>, children),
         nil)

- (id <BNDCommand> )createPersonCommand {
    if (!_createPersonCommand) {
        _createPersonCommand = [MHAddPersonCommand commandWithCreator:self.model];
    }
    return _createPersonCommand;
}

@end