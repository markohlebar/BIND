//
//  MHReversePersonNameCommand.m
//  BIND
//
//  Created by Marko Hlebar on 15/04/2015.
//  Copyright (c) 2015 Marko Hlebar. All rights reserved.
//

#import "MHReversePersonNameCommand.h"
#import "MHPerson.h"

@interface MHReversePersonNameCommand ()
@property (nonatomic, strong) MHPerson *person;
@end

@implementation MHReversePersonNameCommand

+ (instancetype)commandWithPerson:(MHPerson *)person {
    return [[self alloc] initWithPerson:person];
}

- (instancetype)initWithPerson:(MHPerson *)person {
    self = [super init];
    if (self) {
        _person = person;
    }
    return self;
}

- (void)execute {
    _person.fullName = [self reverseString:_person.fullName];
}

- (NSString *)reverseString:(NSString *)string {
    NSMutableString *reversedString = [NSMutableString stringWithCapacity:[string length]];
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:(NSStringEnumerationReverse | NSStringEnumerationByComposedCharacterSequences)
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                [reversedString appendString:substring];
                            }];
    return reversedString.copy;
}

@end
