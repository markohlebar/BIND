//
//  BNDURLToImageTransformerSpec.m
//  BIND
//
//  Created by Marko Hlebar on 26/02/2015.
//  Copyright 2015 Marko Hlebar. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import <UIKit/UIKit.h>
#import "BNDURLToImageTransformer.h"

typedef void(^VoidBlock)(void);

SPEC_BEGIN(BNDURLToImageTransformerSpec)

describe(@"BNDURLToImageTransformer", ^{
    __block BNDURLToImageTransformer *transformer = nil;
    __block void (^urlResponseBlock)(NSURLResponse*, NSData*, NSError*);
    
    NSString *imagePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"white" ofType:@"png"];
    UIImage *testImage = [UIImage imageWithContentsOfFile:imagePath];
    __block NSData *testImageData = UIImagePNGRepresentation(testImage);
    
    void (^simulateReceiveImage)(VoidBlock) = ^(VoidBlock transformBlock) {
        KWCaptureSpy *spy = [NSURLConnection captureArgument:@selector(sendAsynchronousRequest:queue:completionHandler:)
                                                     atIndex:2];
        transformBlock();
        urlResponseBlock = spy.argument;
        urlResponseBlock(nil, testImageData, nil);
    };
    
    beforeEach(^{
        transformer = [BNDURLToImageTransformer new];
    });
    
    it(@"Should be able to transform an image URL to an image", ^{
        __block UIImage *receivedImage = nil;
        BNDAsyncValueTransformBlock transformBlock = ^(UIImage *image) {
            receivedImage = image;
        };
    
        simulateReceiveImage(^{
            [transformer asyncTransformValue:[NSURL URLWithString:@"http://www.google.com"]
                              transformBlock:transformBlock];
        });
        
        NSData *receivedImageData = UIImagePNGRepresentation(receivedImage);
        [[receivedImageData should] equal:testImageData];
    });
});

SPEC_END
