//
//  BNDNilToEmptyStringTransformer.m
//  BINDPlugin
//
//  Created by Marko Hlebar on 07/12/2014.
//  Copyright (c) 2014 Marko Hlebar. All rights reserved.
//

#import "BNDNilToEmptyStringTransformer.h"

@implementation BNDNilToEmptyStringTransformer

- (id)transformedValue:(id)value {
    return value ?: @"";
}

- (id)reverseTransformedValue:(id)value {
    return value;
}

@end
