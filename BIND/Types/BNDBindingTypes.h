//
//  BNDBindingTypes.h
//  BIND
//
//  Created by Marko Hlebar on 21/11/2014.
//  Copyright (c) 2014 Marko Hlebar. All rights reserved.
//

#ifndef BIND_BNDBindingTypes_h
#define BIND_BNDBindingTypes_h

typedef NS_ENUM(NSInteger, BNDBindingDirection) {
    /**
     *  ~> left object passes values to right object.
     */
    BNDBindingDirectionLeftToRight = 0,
    
    /**
     *  <~ right object passes values to left object.
     */
    BNDBindingDirectionRightToLeft = 1,
    
    /**
     *  <> binding is bidirectional.
     */
    BNDBindingDirectionBoth = 2,
};

typedef NS_ENUM(BOOL, BNDBindingTransformDirection) {
    /**
     *  Transform direction is executed from object to otherObject.
     */
    BNDBindingTransformDirectionLeftToRight = 0,
    
    /**
     *  Transform direction is executed from otherObject to object.
     */
    BNDBindingTransformDirectionRightToLeft = 1,
};

typedef id BNDAction;

#endif
