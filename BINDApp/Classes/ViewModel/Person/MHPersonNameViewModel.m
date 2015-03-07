//
//  MHPersonNameViewModel.m
//  MVVM
//
//  Created by Marko Hlebar on 02/11/2014.
//  Copyright (c) 2014 Marko Hlebar. All rights reserved.
//

#import "MHPersonNameViewModel.h"
#import "MHPerson.h"

@implementation MHPersonNameViewModel

- (void)setHexColorCode:(NSString *)hexColorCode {
    self.person.hexColorCode = hexColorCode;
}

- (NSString *)hexColorCode {
    return self.person.hexColorCode;
}

- (void)setName:(NSString *)name {
    self.person.fullName = name;
}

- (NSString *)name {
    return self.person.fullName;
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