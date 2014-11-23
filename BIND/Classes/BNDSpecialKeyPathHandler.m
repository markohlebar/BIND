//
//  BNDBindingSpecialKeyPathsHandler.m
//  BIND
//
//  Created by Marko Hlebar on 21/11/2014.
//  Copyright (c) 2014 Marko Hlebar. All rights reserved.
//

#import "BNDSpecialKeyPathHandler.h"
#import "BNDSpecialKeyPathHandling.h"
#import "BNDBinding.h"

@interface BNDBinding ()

@property (nonatomic, weak) id leftObject;
@property (nonatomic, weak) id rightObject;
@property (nonatomic, strong) NSString *leftKeyPath;
@property (nonatomic, strong) NSString *rightKeyPath;

@end

@implementation BNDSpecialKeyPathHandler

+ (void)handleSpecialKeyPathsForBinding:(BNDBinding *)binding {
    for (NSString *specialKeyPath in [BNDSpecialKeyPathHandler specialKeyPaths]) {
        if ([binding.leftKeyPath rangeOfString:specialKeyPath].location != NSNotFound) {
            id handler = [self objectForObject:binding.leftObject
                                       keyPath:binding.leftKeyPath];
            [self handleSpecialKeyPath:specialKeyPath
                               handler:handler];
                  }
        
        if ([binding.rightKeyPath rangeOfString:specialKeyPath].location != NSNotFound) {
            id handler = [self objectForObject:binding.rightObject
                                       keyPath:binding.rightKeyPath];
            [self handleSpecialKeyPath:specialKeyPath
                               handler:handler];        }
    }
}

+ (id)objectForObject:(NSObject *)object keyPath:(NSString *)keyPath {
    NSArray *components = [keyPath componentsSeparatedByString:@"."];
    if (components.count == 1) {
        return object;
    }
    else if (components.count > 1) {
        //keypath could be object.object.keypath
        NSUInteger index = keyPath.length - [components.lastObject length] - 1;
        keyPath = [keyPath substringToIndex:index];
        return [object valueForKey:keyPath];
    }
    return nil;
}

+ (void)handleSpecialKeyPath:(NSString *)keyPath
                     handler:(id <BNDSpecialKeyPathHandling>)handler {
    if ([handler respondsToSelector:@selector(handleSpecialKeyPath:)]) {
        [handler handleSpecialKeyPath:keyPath];
    }
}

+ (NSArray *)specialKeyPaths {
    return @[
             UIButtonTouchUpInsideKeyPath
             ];
}

@end
