//
//  BNDTestObjects.h
//  BIND
//
//  Created by Marko Hlebar on 30/10/2014.
//  Copyright (c) 2014 Marko Hlebar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Car : NSObject
@property (readwrite) float speed;
@property (nonatomic, copy) NSString *make;
@end

@interface Engine : NSObject
@property (readwrite) float rpm;
@end

@interface ParkingTicket : NSObject;
@property (nonatomic, copy) NSString *carMake;
@end

@interface RPMToSpeedTransformer : NSValueTransformer

@end