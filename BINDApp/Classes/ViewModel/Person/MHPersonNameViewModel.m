//
//  MHPersonNameViewModel.m
//  MVVM
//
//  Created by Marko Hlebar on 02/11/2014.
//  Copyright (c) 2014 Marko Hlebar. All rights reserved.
//

#import "MHPersonNameViewModel.h"
#import "MHPerson.h"
#import "MHReversePersonNameCommand.h"

@implementation MHPersonNameViewModel

- (instancetype)initWithModel:(MHPerson *)person {
    self = [super initWithModel:person];
    if (self) {
        [self loadBindings];
        [self loadCommands];
    }
    return self;
}

- (void)loadCommands {
    self.reverseNameCommand = [MHReversePersonNameCommand commandWithPerson:self.person];
}

- (void)loadBindings {
    BIND(self.person, fullName, <>, self, name);
}

- (void)setHexColorCode:(NSString *)hexColorCode {
    self.person.hexColorCode = hexColorCode;
}

- (NSString *)hexColorCode {
    return self.person.hexColorCode;
}

- (NSString *)ID {
    return [self.person.ID stringValue];
}

- (NSString *)identifier {
    static NSString *_nameIdentifier = @"MHNameTableCell";
    return _nameIdentifier;
}

- (CGFloat)cellHeight {
    return 44;
}

@end