//
//  MHPersonCreator.m
//  BIND
//
//  Created by Marko Hlebar on 25/04/2015.
//  Copyright (c) 2015 Marko Hlebar. All rights reserved.
//

#import "MHPersonCreator.h"
#import "MHPersonFetcher.h"

@interface MHPersonCreator ()
@property (nonatomic, strong) MHPersonFetcher *fetcher;
@property (nonatomic, strong) NSArray *fetchedPersonae;
@end

@implementation MHPersonCreator {
    NSUInteger _createIndex;
    NSMutableArray *_personae;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _createIndex = 0;
        _personae = [NSMutableArray new];
        _fetcher = [MHPersonFetcher new];
        [self loadAllPersons];
    }
    return self;
}

- (void)loadAllPersons {
    __weak typeof(self) weakSelf = self;
    [_fetcher fetchPersonae:^(NSArray *personae) {
        weakSelf.fetchedPersonae = personae;
    }];
}

- (void)create {
    [self insertObject:self.fetchedPersonae[_createIndex] inPersonaeAtIndex:_createIndex];
    _createIndex++;
}

- (void)insertObject:(NSObject *)object inPersonaeAtIndex:(NSUInteger)index {
    [_personae insertObject:object atIndex:index];
}

- (NSArray *)personae {
    return _personae;
}

@end
