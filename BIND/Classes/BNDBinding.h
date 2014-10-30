//
//  BNDBinding.h
//  BIND
//
//  Created by Marko Hlebar on 27/10/2014.
//  Copyright (c) 2014 Marko Hlebar. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, BNDBindingInitialAssignment) {
    BNDBindingInitialAssignmentNone = 0,
    BNDBindingInitialAssignmentLeft = 1,
    BNDBindingInitialAssignmentRight = 2
};

@interface BNDBinding : NSObject

/**
 *  BIND is a special syntax to bind values at keyPath for an object
 *  to another object's value at keyPath.
 *  The syntax is objectKeyPath->otherObjectKeyPath|MHFloatToStringTransformer
 *  where MHFloatToStringTransformer is the optional NSValueTransformer subclass you want to use,
 *  objectKeyPath is the keyPath of bound object, otherObjectKeyPath is the key path of other bound object.
 */
@property (nonatomic, strong) NSString *BIND;

/**
 *  This property determines which value is assigned as initial value.
 *  Default: BNDBindingInitialAssignmentLeft (otherKeyPath assigns value to keyPath)
 */
@property (nonatomic, readonly) BNDBindingInitialAssignment initialAssignment;

/**
 *  A bound object.
 */
@property (nonatomic, readonly) id object;

/**
 *  An object's keyPath.
 */
@property (nonatomic, copy, readonly) NSString *keyPath;

/**
 *  Other bound object.
 */
@property (nonatomic, readonly) id otherObject;

/**
 *  An other bound object's keyPath.
 */
@property (nonatomic, copy, readonly) NSString *otherKeyPath;

/**
 *  Value transfromer for transforming values coming from object to other object and reverse.
 *  Transforms are executed as follows;
 *  When object assigns value to otherObject, transformValue: is called.
 *  When otherObject assigns value to object, reverseTransformValue: is called.
 */
@property (nonatomic, strong) NSValueTransformer *valueTransformer;

/**
 *  Binds an object's value at keyPath to anotherObjects value at keyPath.
 *  The system will assign otherObject's value as object's value on initialization.
 *
 *  @param object       object
 *  @param keyPath      a keyPath to object's property
 *  @param otherObject  other object
 *  @param otherKeyPath a keyPath to other object's property
 *
 *  @return a data binding object.
 */
+ (BNDBinding *)bindingWithObject:(id)object
                          keyPath:(NSString *)keyPath
                       withObject:(id)otherObject
                          keyPath:(NSString *)otherKeyPath;

/**
 *  Binds an object's value at keyPath to anotherObjects value at keyPath.
 *  The system will assign otherObject's value as object's value on initialization.
 *
 *  @param object       object
 *  @param keyPath      a keyPath to object's property
 *  @param otherObject  other object
 *  @param otherKeyPath a keyPath to other object's property
 *  @param transformer  a custom transformer object
 *
 *  @return a data binding object.
 */
+ (BNDBinding *)bindingWithObject:(id)object
                          keyPath:(NSString *)keyPath
                       withObject:(id)otherObject
                          keyPath:(NSString *)otherKeyPath
                      transformer:(NSValueTransformer *)transformer;

/**
 *  Binds an object's value at keyPath to anotherObjects value at keyPath.
 *  The system will assign otherObject's value as object's value on initialization.
 *
 *  @param object             object
 *  @param keyPath            a keyPath to object's property
 *  @param otherObject        other object
 *  @param otherKeyPath       a keyPath to other object's property
 *  @param transformer        a custom transformer object
 *  @param initialAssignment  initial value assignment direction
 *
 *  @return a data binding object.
 */
+ (BNDBinding *)bindingWithObject:(id)object
                          keyPath:(NSString *)keyPath
                       withObject:(id)otherObject
                          keyPath:(NSString *)otherKeyPath
                      transformer:(NSValueTransformer *)transformer
                initialAssignment:(BNDBindingInitialAssignment)initialAssignment;

/**
 *  Builds the bindings reusing previously set keyPaths.
 *  This removes all previous bindings on previously set objects,
 *  and builds bindings for keyPaths with new objects.
 *  This is useful in situations where you want to reuse the binding,
 *  and just update the objects being bound i.e. on UITableViewCell reuse.
 *
 *  @param object      object
 *  @param otherObject other object
 */
- (void)bindObject:(id)object
       otherObject:(id)otherObject;

/**
 *  Removes all bindings.
 */
- (void)unbind;

@end
