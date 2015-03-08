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

static inline NSString *bndShorthandKeypathForObject(id object);

static inline BNDBinding* bndBIND(id left,
                                  NSString *leftKeypath,
                                  NSString *direction,
                                  id right,
                                  NSString *rightKeyPath,
                                  NSString *transformDirection,
                                  Class transformerClass) {
    if ([leftKeypath isEqualToString:@""]) {
        leftKeypath = bndShorthandKeypathForObject(left);
    }
    
    if ([rightKeyPath isEqualToString:@""]) {
        rightKeyPath = bndShorthandKeypathForObject(right);
    }
    
    NSString *format = transformerClass ? @"%@%@%@|%@%@" : @"%@%@%@%@%@";
    NSString *transformer = transformerClass ? NSStringFromClass(transformerClass) : @"";
    NSString *BIND = [NSString stringWithFormat:format,leftKeypath, direction, rightKeyPath, transformDirection, transformer];
    BNDBinding *binding = [BNDBinding bindingWithBIND:BIND];
    [binding bindLeft:left withRight:right];
    return binding;
}

static inline NSDictionary *bndDefaultShorthands() {
    return @{
             @"UILabel" : @"text",
             @"UITextField" : @"text",
             @"UITextView" : @"text",
             @"UIButton" : @"onTouchUpInside",
             @"UITableViewCell" : @"onTouchUpInside",
             @"UIImageView" : @"image",
             @"UIScrollView" : @"contentOffset"
             };
}

static NSMutableDictionary *_bndShorthandMap = nil;

static inline NSDictionary *bndGetRegisteredShorthands() {
    if (!_bndShorthandMap) {
        _bndShorthandMap = bndDefaultShorthands().mutableCopy;
    }
    return _bndShorthandMap.copy;
}

static inline void bndRegisterShorthands(NSDictionary *shorthands) {
    [_bndShorthandMap addEntriesFromDictionary:shorthands];
}

static inline NSString *bndShorthandKeypathForObject(id object) {
    return bndGetRegisteredShorthands()[NSStringFromClass([object class])];
}

#define BIND(left, leftKeyPath, direction, right, rightKeyPath) \
bndBIND(left, @keypath(left,leftKeyPath), @metamacro_stringify(direction), right, @keypath(right,rightKeyPath), @"", nil)

#define BINDT(left, leftKeyPath, direction, right, rightKeyPath, TransformClass) \
BINDNT(left, leftKeyPath, direction, right, rightKeyPath, , TransformClass)

#define BINDNT(left, leftKeyPath, direction, right, rightKeyPath, transformDirection, TransformClass) \
bndBIND(left, @keypath(left,leftKeyPath), @metamacro_stringify(direction), right, @keypath(right,rightKeyPath), @metamacro_stringify(transformDirection), [TransformClass class])

#pragma mark - Shorthands

#define BINDS(left, direction, right) \
bndBIND(left, @"", @metamacro_stringify(direction), right, @"", @"", nil)

#define BINDSL(left, direction, right, rightKeyPath) \
bndBIND(left, @"", @metamacro_stringify(direction), right, @keypath(right,rightKeyPath), @"", nil)

#define BINDSR(left, leftKeyPath, direction, right) \
bndBIND(left, @keypath(left,leftKeyPath), @metamacro_stringify(direction), right, @"", @"", nil)

#endif
