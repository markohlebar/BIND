//
//  MHPersonParser.m
//  MVVM
//
//  Created by Marko Hlebar on 25/10/2014.
//  Copyright (c) 2014 Marko Hlebar. All rights reserved.
//

#import "MHPersonFetcher.h"
#import "MHPerson.h"

@implementation MHPersonFetcher {
    NSOperationQueue *_operationQueue;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _operationQueue = [NSOperationQueue new];
    }
    return self;
}

- (void)fetchPersonae:(MHPersonaeBlock)personaeBlock {
    NSBlockOperation *blockOperation = [NSBlockOperation blockOperationWithBlock:^{
        NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"persons" ofType:@"json"];
        NSData *jsonData = [NSData dataWithContentsOfFile:jsonPath];
        NSArray *dictionaries = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                options:0
                                                                  error:nil];
        __block NSMutableArray *personae = [NSMutableArray new];
        for (NSDictionary *personDictionary in dictionaries) {
            MHPerson *person = [MHPerson modelWithDictionary:personDictionary];
            [personae addObject:person];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            personaeBlock(personae.copy);
        });
    }];
    [_operationQueue addOperation:blockOperation];
}

@end
