//
//  NSObject+BNDCommand.m
//  BIND
//
//  Created by Marko Hlebar on 02/04/2015.
//  Copyright (c) 2015 Marko Hlebar. All rights reserved.
//

#import "NSObject+BNDCommand.h"
#import "BNDCommand.h"
#import <objc/runtime.h>

@implementation NSObject (BNDCommand)

- (void)setBnd_command:(id)bnd_command {
    [self.bnd_commandObject execute];
}

- (id)bnd_command {
    return nil;
}

- (void)setBnd_commandObject:(id<BNDCommand>)bnd_commandObject {
    objc_setAssociatedObject(self, @selector(bnd_commandObject), bnd_commandObject, OBJC_ASSOCIATION_RETAIN);
}

- (id<BNDCommand>)bnd_commandObject {
    return objc_getAssociatedObject(self, @selector(bnd_commandObject));
}

@end
