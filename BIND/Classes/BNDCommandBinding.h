//
//  BNDCommandBinding.h
//  BIND
//
//  Created by Marko Hlebar on 20/04/2015.
//  Copyright (c) 2015 Marko Hlebar. All rights reserved.
//

#import "BNDBinding.h"

@interface BNDCommandBinding : BNDBinding
@property (nonatomic, copy, readonly) NSString *commandKeyPath;
@property (nonatomic, copy, readonly) NSString *actionKeyPath;

+ (BNDCommandBinding *)bindingWithCommandKeyPath:(NSString *)commandKeyPath
                                   actionKeyPath:(NSString *)actionKeyPath;

@end
