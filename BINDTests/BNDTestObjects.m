//
//  BNDTestObjects.m
//  BIND
//
//  Created by Marko Hlebar on 30/10/2014.
//  Copyright (c) 2014 Marko Hlebar. All rights reserved.
//

#import "BNDTestObjects.h"

@implementation Car

@end

@implementation Engine

@end

@implementation GasPedal

@end

@implementation ParkingTicket

@end

#pragma mark - UI Tests

@implementation ViewModel
@end

@implementation TableViewCell
- (void)dealloc {
}
@end

#pragma mark - Transformers

@implementation RPMToSpeedTransformer

- (id)transformedValue:(id)rpm {
    float speed = [rpm floatValue] / 100;
    return @(speed);
}

- (id)reverseTransformedValue:(id)speed {
    float rpm = [speed floatValue] * 100;
    return @(rpm);
}

@end

@implementation AsyncRPMToSpeedTransformer

- (void)asyncTransformValue:(id)rpm transformBlock:(BNDAsyncValueTransformBlock)transformBlock {
    __block float speed = [rpm floatValue] / 100;

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        transformBlock(@(speed));
    });
}

- (void)reverseAsyncTransformValue:(id)speed transformBlock:(BNDAsyncValueTransformBlock)transformBlock {
    __block float rpm = [speed floatValue] * 100;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        transformBlock(@(rpm));
    });
}

@end