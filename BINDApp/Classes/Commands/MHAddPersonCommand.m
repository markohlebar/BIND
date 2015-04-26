//
//  MHAddPersonCommand.m
//  BIND
//
//  Created by Marko Hlebar on 25/04/2015.
//  Copyright (c) 2015 Marko Hlebar. All rights reserved.
//

#import "MHAddPersonCommand.h"

@implementation MHAddPersonCommand

+ (instancetype)commandWithCreator:(id <MHCreator> )creator {
    return [[self alloc] initWithCreator:creator];
}

- (instancetype)initWithCreator:(id<MHCreator> )creator {
    self = [super init];
    if (self) {
        _creator = creator;
    }
    return self;
}

- (void)execute {
    [_creator create];
}

@end
