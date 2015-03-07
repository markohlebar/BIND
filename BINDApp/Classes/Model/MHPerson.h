//
//  MHPerson.h
//  MVVM
//
//  Created by Marko Hlebar on 25/10/2014.
//  Copyright (c) 2014 Marko Hlebar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MHModel.h"

@interface MHPerson : NSObject <MHModel>
@property (nonatomic, copy, readonly) NSNumber *ID;
@property (nonatomic, copy) NSString *fullName;
@property (nonatomic, copy) NSString *hexColorCode;

@end
