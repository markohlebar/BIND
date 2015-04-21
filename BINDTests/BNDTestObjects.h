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
#import "BNDAsyncValueTransformer.h"

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

#pragma mark - UI Tests

@class Command;
@interface ViewModel : NSObject <BNDViewModel>
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, strong) ViewModel *childViewModel;
@property (nonatomic, strong) Command *command;
@end

@interface TableViewCell : BNDTableViewCell
@property (nonatomic, strong) TableViewCell *childCell;
@end

#pragma mark - Transformers

@interface RPMToSpeedTransformer : NSValueTransformer
@end

@interface AsyncRPMToSpeedTransformer : BNDAsyncValueTransformer
@end

#pragma mark - Command

@interface Command : NSObject <BNDCommand>
@property (getter=isExecuted) BOOL executed;
@end
