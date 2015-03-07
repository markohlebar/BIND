//
//  BNDURLToImageTransformer.m
//  BIND
//
//  Created by Marko Hlebar on 26/02/2015.
//  Copyright (c) 2015 Marko Hlebar. All rights reserved.
//

#import "BNDURLToImageTransformer.h"
#import <UIKit/UIKit.h>

@implementation BNDURLToImageTransformer

- (void)asyncTransformValue:(NSURL *)value
             transformBlock:(BNDAsyncValueTransformBlock)transformBlock {
    NSURLRequest *request = [NSURLRequest requestWithURL:value];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue new]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               if (data) {
                                   UIImage *image = [UIImage imageWithData:data];
                                   transformBlock(response.URL, image);
                               }
                           }];
}

+ (BOOL)allowsReverseTransformation {
    return NO;
}

@end
