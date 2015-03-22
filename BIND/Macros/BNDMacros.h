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

static inline BNDBinding* bndBINDObserve(id left,
                                        NSString *leftKeypath) {
    if ([leftKeypath isEqualToString:@""]) {
        leftKeypath = bndShorthandKeypathForObject(left);
    }
    
    BNDBinding *binding = [BNDBinding bindingWithBIND:[NSString stringWithFormat:@"%@->voidKeyPath", leftKeypath]];
    [binding bindLeft:left withRight:binding];
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

static inline NSMutableDictionary *bndGetRegisteredShorthands() {
    if (!_bndShorthandMap) {
        _bndShorthandMap = bndDefaultShorthands().mutableCopy;
    }
    return _bndShorthandMap;
}

static inline void bndRegisterShorthands(NSDictionary *shorthands) {
    [bndGetRegisteredShorthands() addEntriesFromDictionary:shorthands];
}

static inline NSString *bndShorthandKeypathForObject(id object) {
    return bndGetRegisteredShorthands()[NSStringFromClass([object class])];
}

/**
 *  BIND.
 *
 *  @param left         left object.
 *  @param leftKeyPath  left object's keypath.
 *  @param direction    binding direction.
 *  @param right        right object.
 *  @param rightKeyPath right object's keypath.
 *
 *  @return a binding.
 */
#define BIND(left, leftKeyPath, direction, right, rightKeyPath) \
bndBIND(left, @keypath(left,leftKeyPath), @metamacro_stringify(direction), right, @keypath(right,rightKeyPath), @"", nil)

/**
 *  BIND transform.
 *
 *  @param left           left object.
 *  @param leftKeyPath    left object's keypath.
 *  @param direction      binding direction.
 *  @param right          right object.
 *  @param rightKeyPath   right object's keypath.
 *  @param TransformClass a transform class.
 *
 *  @return a binding.
 */
#define BINDT(left, leftKeyPath, direction, right, rightKeyPath, TransformClass) \
bndBIND(left, @keypath(left,leftKeyPath), @metamacro_stringify(direction), right, @keypath(right,rightKeyPath), @"", [TransformClass class])

/**
 *  BIND reverse transform.
 *
 *  @param left           left object.
 *  @param leftKeyPath    left object's keypath.
 *  @param direction      binding direction.
 *  @param right          right object.
 *  @param rightKeyPath   right object's keypath.
 *  @param TransformClass a transform class.
 *
 *  @return a binding.
 */
#define BINDRT(left, leftKeyPath, direction, right, rightKeyPath, TransformClass) \
bndBIND(left, @keypath(left,leftKeyPath), @metamacro_stringify(direction), right, @keypath(right,rightKeyPath), @"!", [TransformClass class])

#pragma mark - Shorthands

/**
 *  BIND shorthand.
 *
 *  @param left      left object which has a defined shorthand.
 *  @param direction binding direction.
 *  @param right     right object which has a defined shorthand.
 *
 *  @return a binding.
 */
#define BINDS(left, direction, right) \
bndBIND(left, @"", @metamacro_stringify(direction), right, @"", @"", nil)

/**
 *  BIND shorthand left.
 *
 *  @param left         left object which has a defined shorthand.
 *  @param direction    binding direction.
 *  @param right        right object.
 *  @param rightKeyPath right
 *
 *  @return a binding.
 */
#define BINDSL(left, direction, right, rightKeyPath) \
bndBIND(left, @"", @metamacro_stringify(direction), right, @keypath(right,rightKeyPath), @"", nil)

/**
 *  BIND shorthand right.
 *
 *  @param left        left object.
 *  @param leftKeyPath left object's keypath.
 *  @param direction   binding direction.
 *  @param right       right object which has a defined shorthand.
 *
 *  @return a binding.
 */
#define BINDSR(left, leftKeyPath, direction, right) \
bndBIND(left, @keypath(left,leftKeyPath), @metamacro_stringify(direction), right, @"", @"", nil)

#pragma mark - Target-Action

/**
 *  BIND observe.
 *  Observes one property of an object.
 *
 *  @param observable        an object we're observing.
 *  @param observableKeyPath an object's property we're observing.
 *
 *  @return a binding.
 */
#define BINDO(observable, observableKeyPath) \
bndBINDObserve(observable, @keypath(observable,observableKeyPath))

/**
 *  BIND observe shorthand.
 *  Observes one property of an object.
 *
 *  @param observable object to observe.
 *
 *  @return a binding.
 */
#define BINDOS(observable) \
bndBINDObserve(observable, @"")

/**
 *  This is a shorthand for creating bindings in a BNDView environment.
 *
 *  @param viewModelClass a view model class
 *  @param ...            nil terminated list of BINDViewModel bindings
 */
#define BINDINGS(viewModelClass, ...) \
@synthesize bindings = _bindings; \
- (NSArray *)bindings { \
viewModelClass *viewModel = (viewModelClass *)self.viewModel; \
if (!_bindings) { \
_bindings = [NSArray arrayWithObjects:__VA_ARGS__]; \
} \
return _bindings; \
}

/**
 *  This is a shorthand to use only in couple with BINDINGS shorthand.
 *  It assumes that the left object is a viewModel property of the BNDView.
 */
#define BINDViewModel(leftKeyPath, direction, rightKeyPath) \
bndBIND(viewModel, @keypath(viewModel,leftKeyPath), @metamacro_stringify(direction), self, @keypath(self,rightKeyPath), @"", nil)

#endif
