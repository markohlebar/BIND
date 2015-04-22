//
//  BNDCommandBinding.h
//  BIND
//
//  Created by Marko Hlebar on 20/04/2015.
//  Copyright (c) 2015 Marko Hlebar. All rights reserved.
//

#import "BNDBinding.h"

@interface BNDCommandBinding : BNDBinding

/**
 *  keypath to a property that implements BNDCommand protocol
 */
@property (nonatomic, copy, readonly) NSString *commandKeyPath;

/**
 *  keypath to any property
 */
@property (nonatomic, copy, readonly) NSString *actionKeyPath;

/**
 *  Creates a command binding.
 *  commandKeyPath corresponds to leftObject, and actionKeyPath corresponds to rightObject.
 *
 *  @param commandKeyPath keypath to a property that implements BNDCommand protocol
 *  @param actionKeyPath  keypath to any property
 *
 *  @return a binding.
 */
+ (BNDCommandBinding *)bindingWithCommandKeyPath:(NSString *)commandKeyPath
                                   actionKeyPath:(NSString *)actionKeyPath;

@end
