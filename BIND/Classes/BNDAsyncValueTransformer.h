//
//  BNDAsyncValueTransformer.h
//  BIND
//
//  Created by Marko Hlebar on 26/02/2015.
//  Copyright (c) 2015 Marko Hlebar. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^BNDAsyncValueTransformBlock)(id value, id transformedValue);

@interface BNDAsyncValueTransformer : NSValueTransformer

/**
 *  Asynchronously transforms a value and returns the result in a block.
 *
 *  @param value          value to transform.
 *  @param transformBlock a block containing the transformed value.
 */
- (void)asyncTransformValue:(id)value
             transformBlock:(BNDAsyncValueTransformBlock)transformBlock;

/**
 *  Asynchronously reverse transforms a value and returns the result in a block.
 *
 *  @param value          value to reverse transform.
 *  @param transformBlock a block containing the transformed value.
 */
- (void)reverseAsyncTransformValue:(id)value
                    transformBlock:(BNDAsyncValueTransformBlock)transformBlock;

@end
