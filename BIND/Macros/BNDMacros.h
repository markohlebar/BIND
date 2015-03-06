//
//  BNDMacros.h
//  BIND
//
//  Created by Marko Hlebar on 06/12/2014.
//  Copyright (c) 2014 Marko Hlebar. All rights reserved.
//

#ifndef BIND_BNDMacros_h
#define BIND_BNDMacros_h

#import "BNDBinding.h"
#import <libextobjc/EXTKeyPathCoding.h>

#if TARGET_OS_IPHONE

#import <UIKit/UIKit.h>

#define _BNDViewController  UIViewController
#define _BNDView            UIView
#define _BNDTableViewCell   UITableViewCell
#define _BNDButton          UIButton

#elif TARGET_OS_MAC

#import <AppKit/AppKit.h>

#define _BNDViewController  NSViewController
#define _BNDView            NSView
#define _BNDTableViewCell   NSTableCellView
#define _BNDButton          NSButton

#endif

static inline BNDBinding* bndBIND(id left,
                                  NSString *leftKeypath,
                                  NSString *direction,
                                  id right,
                                  NSString *rightKeyPath,
                                  NSString *transformDirection,
                                  NSString *valueTransformer) {
    NSString *BIND = [NSString stringWithFormat:@"%@%@%@|%@%@",leftKeypath, direction, rightKeyPath, transformDirection, valueTransformer];
    BNDBinding *binding = [BNDBinding bindingWithBIND:BIND];
    [binding bindLeft:left withRight:right];
    return binding;
}

#define BIND(...) \
metamacro_if_eq(5, metamacro_argcount(__VA_ARGS__))(BIND1(__VA_ARGS__))\
(metamacro_if_eq(6, metamacro_argcount(__VA_ARGS__))(BIND2(__VA_ARGS__))(BIND3(__VA_ARGS__)))

#define BIND1(LEFT_TARGET, LEFT, DIRECTION, RIGHT_TARGET, RIGHT) \
bndBIND(LEFT_TARGET, @keypath(LEFT_TARGET,LEFT), @metamacro_stringify(DIRECTION), RIGHT_TARGET, @keypath(RIGHT_TARGET,RIGHT), @"", @"")

#define BIND2(LEFT_TARGET, LEFT, DIRECTION, RIGHT_TARGET, RIGHT, TRANSFORM) \
bndBIND(LEFT_TARGET, @keypath(LEFT_TARGET,LEFT), @metamacro_stringify(DIRECTION), RIGHT_TARGET, @keypath(RIGHT_TARGET,RIGHT), @"", @metamacro_stringify(TRANSFORM))

#define BIND3(LEFT_TARGET, LEFT, DIRECTION, RIGHT_TARGET, RIGHT, TRANSFORM_DIRECTION, TRANSFORM) \
bndBIND(LEFT_TARGET, @keypath(LEFT_TARGET,LEFT), @metamacro_stringify(DIRECTION), RIGHT_TARGET, @keypath(RIGHT_TARGET,RIGHT), @metamacro_stringify(TRANSFORM_DIRECTION), @metamacro_stringify(TRANSFORM))

#endif
