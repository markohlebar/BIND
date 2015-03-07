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
                                  Class transformerClass) {
    NSString *format = transformerClass ? @"%@%@%@|%@%@" : @"%@%@%@%@%@";
    NSString *transformer = transformerClass ? NSStringFromClass(transformerClass) : @"";
    NSString *BIND = [NSString stringWithFormat:format,leftKeypath, direction, rightKeyPath, transformDirection, transformer];
    BNDBinding *binding = [BNDBinding bindingWithBIND:BIND];
    [binding bindLeft:left withRight:right];
    return binding;
}

#define BIND(left, leftKeyPath, direction, right, rightKeyPath) \
bndBIND(left, @keypath(left,leftKeyPath), @metamacro_stringify(direction), right, @keypath(right,rightKeyPath), @"", nil)

#define BINDT(left, leftKeyPath, direction, right, rightKeyPath, TransformClass) \
BINDNT(left, leftKeyPath, direction, right, rightKeyPath, , TransformClass)

#define BINDNT(left, leftKeyPath, direction, right, rightKeyPath, transformDirection, TransformClass) \
bndBIND(left, @keypath(left,leftKeyPath), @metamacro_stringify(direction), right, @keypath(right,rightKeyPath), @metamacro_stringify(transformDirection), [TransformClass class])

#endif
