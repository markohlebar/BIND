//
//  MHPersonColorViewModel.m
//  MVVM
//
//  Created by Marko Hlebar on 02/11/2014.
//  Copyright (c) 2014 Marko Hlebar. All rights reserved.
//

#import "MHPersonColorViewModel.h"
#import "MHPerson.h"
#import "UIColor+Hex.h"


@implementation MHPersonColorViewModel

- (UIColor *)color {
    return [UIColor colorFromHexString:self.person.hexColorCode];
}

- (NSString *)identifier {
    static NSString *_colorIdentifier = @"MHColorTableCell";
    return _colorIdentifier;
}

- (CGFloat)cellHeight {
    return 80;
}

@end