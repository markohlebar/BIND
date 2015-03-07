//
//  MHPerson.m
//  MVVM
//
//  Created by Marko Hlebar on 25/10/2014.
//  Copyright (c) 2014 Marko Hlebar. All rights reserved.
//

#import "MHPerson.h"

@implementation MHPerson

+ (instancetype)modelWithDictionary:(NSDictionary *)dictionary {
    return [[self alloc] initWithDictionary:dictionary];
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        _ID = [dictionary[@"id"] copy];
        _fullName = [dictionary[@"name"] copy];
        _hexColorCode = [dictionary[@"color"] copy];
    }
    return self;
}

- (void)setHexColorCode:(NSString *)hexColorCode {
    _hexColorCode = hexColorCode;
}

@end
