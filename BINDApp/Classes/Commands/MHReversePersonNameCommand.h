//
//  MHReversePersonNameCommand.h
//  BIND
//
//  Created by Marko Hlebar on 15/04/2015.
//  Copyright (c) 2015 Marko Hlebar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BNDMacros.h"

@class MHPerson;
@interface MHReversePersonNameCommand : NSObject <BNDCommand>

+ (instancetype)commandWithPerson:(MHPerson *)person;

@end
