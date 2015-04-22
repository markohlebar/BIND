//
//  MHPersonViewModel.m
//  MVVM
//
//  Created by Marko Hlebar on 02/11/2014.
//  Copyright (c) 2014 Marko Hlebar. All rights reserved.
//

#import "MHPersonViewModel.h"
#import "MHPerson.h"

@implementation MHPersonViewModel

- (MHPerson *)person {
    return self.model;
}

- (NSString *)identifier {
    NSAssert(NO, @"Implement in concrete subclass");
    return nil;
}

@end