//
//  BNDCommandBinding.m
//  BIND
//
//  Created by Marko Hlebar on 20/04/2015.
//  Copyright (c) 2015 Marko Hlebar. All rights reserved.
//

#import "BNDCommandBinding.h"
#import "BNDCommand.h"

@interface BNDBinding ()
@property (nonatomic, strong) NSString *leftKeyPath;
@property (nonatomic, strong) NSString *rightKeyPath;
@end

@implementation BNDCommandBinding

+ (BNDCommandBinding *)bindingWithCommandKeyPath:(NSString *)commandKeyPath
                                   actionKeyPath:(NSString *)actionKeyPath {
    NSString *BIND = [NSString stringWithFormat:@"%@<~!%@", commandKeyPath, actionKeyPath];
    return [BNDCommandBinding bindingWithBIND:BIND];
}

- (NSString *)commandKeyPath {
    return self.leftKeyPath;
}

- (NSString *)actionKeyPath {
    return self.rightKeyPath;
}

- (void)setLeftObjectValue:(id)value {
    id <BNDCommand> command = [self.leftObject valueForKeyPath:self.commandKeyPath];
    NSAssert([command conformsToProtocol:@protocol(BNDCommand)], @"A command should conform BNDCommand protocol");
    [command execute];
}

@end
