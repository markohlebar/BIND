//
//  BNDTestObjects.h
//  BIND
//
//  Created by Marko Hlebar on 30/10/2014.
//  Copyright (c) 2014 Marko Hlebar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BNDConcreteView.h"
#import "BNDViewModel.h"

@class Engine;
@class GasPedal;

@interface Car : NSObject
@property (readwrite) float speed;
@property (strong) Engine *engine;
@property (strong) GasPedal *gasPedal;
@property (nonatomic, copy) NSString *make;
@end

@interface Engine : NSObject
@property (readwrite) float rpm;
@end

@interface GasPedal : NSObject
@property (readwrite) float percentPressed;
@end

@interface ParkingTicket : NSObject;
@property (nonatomic, copy) NSString *carMake;
@end

@interface RPMToSpeedTransformer : NSValueTransformer

@end

@interface ViewModel : NSObject <BNDViewModel>
@property (nonatomic, strong) NSString *text;
@end

@interface TableViewCell : BNDTableViewCell

@end

