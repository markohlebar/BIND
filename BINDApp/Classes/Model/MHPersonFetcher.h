//
//  MHPersonParser.h
//  MVVM
//
//  Created by Marko Hlebar on 25/10/2014.
//  Copyright (c) 2014 Marko Hlebar. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^MHPersonaeBlock)(NSArray *personae);
@interface MHPersonFetcher : NSObject
- (void)fetchPersonae:(MHPersonaeBlock)personaeBlock;
@end
