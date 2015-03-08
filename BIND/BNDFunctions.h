//
//  BNDFunctions.h
//  BIND
//
//  Created by Marko Hlebar on 07/03/2015.
//  Copyright (c) 2015 Marko Hlebar. All rights reserved.
//

#import "BNDBinding.h"

#ifndef BIND_BNDFunctions_h
#define BIND_BNDFunctions_h

static NSString *const BNDBindingKeyPathSeparator = @".";

/**
 *  Decomposes the object.decomposedObject.path to decomposedObject setPath
 *
 *  @param object           an object for which we are decomposing the keypath.
 *  @param keyPath          a keypath.
 *  @param decomposedObject a reference to a decomposed object.
 *  @param decomposedSetter a reference to a decomposed setter.
 */
static inline void bndDecomposeKeyPath(id object,
                                       NSString *keyPath,
                                       id *decomposedObject,
                                       SEL *decomposedSetter) {
    NSArray *components = [keyPath componentsSeparatedByString:BNDBindingKeyPathSeparator];
    NSString *lastKeyPath = nil;
    if (components.count == 1) {
        *decomposedObject = object;
        lastKeyPath = keyPath;
    }
    else {
        lastKeyPath = [components lastObject];
        
        NSMutableString *decomposedObjectKeyPath = [NSMutableString new];
        [components enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
            BOOL isLastComponent = (idx == components.count - 2);
            *stop = isLastComponent;
            [decomposedObjectKeyPath appendFormat:@"%@%@", obj, isLastComponent ? @"" : BNDBindingKeyPathSeparator];
        }];
        
        *decomposedObject = [object valueForKeyPath:decomposedObjectKeyPath];
    }
    
    NSString *setterString = [NSString stringWithFormat:@"set%@:", lastKeyPath.capitalizedString];
    *decomposedSetter = NSSelectorFromString(setterString);
}

/**
 *  Creates a binding for given parameters.
 *
 *  @param left               left object.
 *  @param leftKeypath        left object key path.
 *  @param direction          binding direction.
 *  @param right              right object.
 *  @param rightKeyPath       right object key path.
 *  @param transformDirection transform direction.
 *  @param transformerClass   transformer class.
 *
 *  @return a binding.
 */
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

#endif
