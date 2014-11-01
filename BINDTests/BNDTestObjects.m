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