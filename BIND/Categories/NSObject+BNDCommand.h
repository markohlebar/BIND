//
//  NSObject+BNDCommand.h
//  BIND
//
//  Created by Marko Hlebar on 02/04/2015.
//  Copyright (c) 2015 Marko Hlebar. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BNDCommand;
@interface NSObject (BNDCommand)
@property (nonatomic) id bnd_command;
@property (nonatomic) id <BNDCommand> bnd_commandObject;
@end
