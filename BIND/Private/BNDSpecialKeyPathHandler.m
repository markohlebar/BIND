//
//  BNDSpecialKeyPathHandler.m
//  BIND
//
//  Created by Marko Hlebar on 21/11/2014.
//  Copyright (c) 2014 Marko Hlebar. All rights reserved.
//

#import "BNDSpecialKeyPathHandler.h"
#import "BNDBinding.h"
#import "BNDSpecialKeyPathHandling.h"
#import "NSString+BNDKeyPathHandling.h"

@interface BNDBinding ()

@property (nonatomic, weak) id leftObject;
@property (nonatomic, weak) id rightObject;
@property (nonatomic, strong) NSString *leftKeyPath;
@property (nonatomic, strong) NSString *rightKeyPath;

@end

@implementation BNDSpecialKeyPathHandler

+ (void)handleSpecialKeyPathsForBinding:(BNDBinding *)binding {
    NSString *leftSpecialKeyPath = [binding.leftKeyPath bnd_lastKeyPathComponent];
    id handler = [self keypathHandlerForObject:binding.leftObject
                                       keyPath:binding.leftKeyPath];
    [self handleSpecialKeyPath:leftSpecialKeyPath
                       handler:handler];
    
    NSString *rightSpecialKeyPath = [binding.rightKeyPath bnd_lastKeyPathComponent];
    handler = [self keypathHandlerForObject:binding.rightObject
                                    keyPath:binding.rightKeyPath];
    [self handleSpecialKeyPath:rightSpecialKeyPath
                       handler:handler];
}

+ (id)keypathHandlerForObject:(NSObject *)object keyPath:(NSString *)keyPath {
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

@end
