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
BINDINGS(MHPerson,
         BINDModel(fullName, <>, name),
         nil);

- (MHReversePersonNameCommand *)reverseNameCommand {
    if (!_reverseNameCommand) {
        _reverseNameCommand = [MHReversePersonNameCommand commandWithPerson:self.person];
    }
    return _reverseNameCommand;
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
