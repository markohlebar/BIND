//
//  MHHexColorTransformer.m
//  MVVM
//
//  Created by Marko Hlebar on 27/10/2014.
//  Copyright (c) 2014 Marko Hlebar. All rights reserved.
//

#import "MHHexColorTransformer.h"
#import <UIKit/UIColor.h>
#import "UIColor+Hex.h"

@implementation MHHexColorTransformer

+ (Class)transformedValueClass {
    return [NSString class];
}

+ (BOOL)allowsReverseTransformation {
    return YES;
}

- (NSString *)transformedValue:(UIColor *)value {
    const CGFloat *components = CGColorGetComponents(value.CGColor);
    CGFloat r = components[0];
    CGFloat g = components[1];
    CGFloat b = components[2];
    NSString *hexString=[NSString stringWithFormat:@"#%02X%02X%02X", (int)(r * 255), (int)(g * 255), (int)(b * 255)];
    return hexString;
}

- (UIColor *)reverseTransformedValue:(NSString *)value {
    return [UIColor colorFromHexString:value];
}

@end
