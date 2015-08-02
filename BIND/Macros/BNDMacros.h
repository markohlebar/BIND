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
#import "BNDCommand.h"
#import "BNDCommandBinding.h"

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

#pragma mark - Debug

#define BNDLog(fmt, ...) [BNDBinding debugEnabled] ? NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__) : 0;

#define BNDLogDeprecated(__DEPRECATED__, __NEW__) NSLog(@"[BIND] %@ is deprecated, use %@ instead.", __DEPRECATED__, __NEW__)


#pragma mark - BNDView

#define BND_VIEW_INTERFACE(__CLASS__, __SUPERCLASS__) \
@interface __CLASS__ : __SUPERCLASS__ <BNDView> { \
NSArray *_bindings; \
} \
@property (nonatomic, strong) IBOutletCollection(BNDBinding) NSArray *bindings; \
@end

#define BND_VIEW_IMPLEMENTATION(__CLASS_NAME__) \
@implementation __CLASS_NAME__ \
BND_VIEW_IMPLEMENT_SET_VIEW_MODEL \
BND_VIEW_IMPLEMENT_VIEW_DID_UPDATE_VIEW_MODEL \
@end

#define BND_VIEW_IMPLEMENT_SET_VIEW_MODEL \
@synthesize bindings = _bindings; \
@synthesize viewModel = _viewModel; \
- (void)setViewModel:(id <BNDViewModel> )viewModel { \
    for (BNDBinding *binding in self.bindings) { \
        if ([self isShorthandBinding:binding]) { \
            [binding bindLeft:viewModel withRight:self]; \
        } \
        else { \
            [binding bindLeft:self withRight:self]; \
        } \
    } \
    [self willChangeValueForKey:@"viewModel"]; \
    _viewModel = viewModel; \
    [self didChangeValueForKey:@"viewModel"]; \
    [self viewDidUpdateViewModel:viewModel]; \
} \
- (BOOL)isShorthandBinding:(BNDBinding *)binding { \
    return [binding.BIND rangeOfString:@"viewModel."].location == NSNotFound; \
} \

#define BND_VIEW_IMPLEMENT_VIEW_DID_UPDATE_VIEW_MODEL \
- (void)viewDidUpdateViewModel:(id <BNDViewModel> )viewModel { \
} \

#pragma mark - BIND DSL HELPER

@interface NSObject (BNDValueTransformer)
+(id)bnd_self;
-(id)bnd_self;
@end

@implementation NSObject (BNDValueTransformer)
+(id)bnd_self {
    return self.class;
}
-(id)bnd_self {
    return self;
}
@end

#pragma mark - BIND DSL

static inline NSString *bndShorthandKeypathForObject(id object);

static inline BNDBinding* bndBIND(id left,
                                  NSString *leftKeypath,
                                  NSString *direction,
                                  id right,
                                  NSString *rightKeyPath,
                                  NSString *transformDirection,
                                  id transformerClass) {
    if ([leftKeypath isEqualToString:@""]) {
        leftKeypath = bndShorthandKeypathForObject(left);
    }
    
    if ([rightKeyPath isEqualToString:@""]) {
        rightKeyPath = bndShorthandKeypathForObject(right);
    }
    
    BOOL hasTransformer = (transformerClass != nil);
    NSString *format = hasTransformer ? @"%@%@%@|%@%@" : @"%@%@%@%@%@";
    NSString *transformer;
    if (hasTransformer) {
        transformer = [transformerClass isKindOfClass:NSString.class] ? transformerClass : NSStringFromClass(transformerClass);
    }
    else {
        transformer = @"";
    }
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
    
    BNDBinding *binding = [BNDBinding bindingWithBIND:[NSString stringWithFormat:@"%@~>voidKeyPath", leftKeypath]];
    [binding bindLeft:left withRight:binding];
    return binding;
}

static inline BNDBinding *bndBINDViewModelCommand(id viewModel,
                                                  NSString *commandKeyPath,
                                                  id viewObject,
                                                  NSString *actionKeyPath) {
    BNDBinding *binding = [BNDCommandBinding bindingWithCommandKeyPath:commandKeyPath
                                                         actionKeyPath:actionKeyPath];
    [binding bindLeft:viewModel withRight:viewObject];
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
bndBIND(left, @keypath(left,leftKeyPath), @metamacro_stringify(direction), right, @keypath(right,rightKeyPath), @"", TransformClass.bnd_self)

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
bndBIND(left, @keypath(left,leftKeyPath), @metamacro_stringify(direction), right, @keypath(right,rightKeyPath), @"!", TransformClass.bnd_self)

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

#define BINDCommand(leftObject, leftKeyPath, command) \
bndBINDCommand(leftObject, @keypath(leftObject, leftKeyPath), command)

/**
 *  This is a shorthand for creating bindings in a BNDView environment.
 *
 *  @param viewModelClass a view model class
 *  @param ...            nil terminated list of BINDViewModel bindings
 */
#define BINDINGS(class, ...) \
- (NSArray *)bindings { \
class *object __unused = nil;\
if ([self respondsToSelector:@selector(viewModel)]) object = [self performSelector:@selector(viewModel)]; \
else if ([self respondsToSelector:@selector(model)]) object = [self performSelector:@selector(model)]; \
if (!_bindings) { \
NSArray *selfBindings = [NSArray arrayWithObjects:__VA_ARGS__]; \
NSArray *superBindings = [super bindings]; \
_bindings = superBindings ? [superBindings arrayByAddingObjectsFromArray:selfBindings] : selfBindings; \
} \
return _bindings; \
}

/**
 *  This is a shorthand to use only in couple with BINDINGS shorthand.
 *  It assumes that the left object is a viewModel property of the BNDView.
 */
#define BINDViewModel(viewModelKeyPath, direction, selfKeyPath) \
bndBIND(object, @keypath(object,viewModelKeyPath), @metamacro_stringify(direction), self, @keypath(self,selfKeyPath), @"", nil)

/**
 *  This is a shorthand to use only in couple with BINDINGS shorthand.
 *  Assuming that the viewModel has a property that implements BNDCommand protocol, 
 *  Whenever there is a change in the actionKeyPath, the command at commandKeyPath is executed.
 */
#define BINDViewModelCommand(commandKeyPath, actionKeyPath) \
bndBINDViewModelCommand(object, @keypath(object, commandKeyPath), self, @keypath(self, actionKeyPath))

#define BINDModel(modelKeyPath, direction, selfKeyPath) BINDViewModel(modelKeyPath, direction, selfKeyPath)


#endif
