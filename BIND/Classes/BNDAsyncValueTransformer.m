//
//  BNDAsyncValueTransformer.m
//  BIND
//
//  Created by Marko Hlebar on 26/02/2015.
//  Copyright (c) 2015 Marko Hlebar. All rights reserved.
//

#import "BNDAsyncValueTransformer.h"

@implementation BNDAsyncValueTransformer

- (void)asyncTransformValue:(id)value
             transformBlock:(BNDAsyncValueTransformBlock)transformBlock {
    [self doesNotRecognizeSelector:_cmd];
}

- (void)reverseAsyncTransformValue:(id)value
                    transformBlock:(BNDAsyncValueTransformBlock)transformBlock {
    [self doesNotRecognizeSelector:_cmd];
}

@end
