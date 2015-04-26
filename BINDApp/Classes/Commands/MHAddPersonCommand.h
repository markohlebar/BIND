//
//  MHAddPersonCommand.h
//  BIND
//
//  Created by Marko Hlebar on 25/04/2015.
//  Copyright (c) 2015 Marko Hlebar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BNDCommand.h"

@protocol MHCreator <NSObject>
- (void)create;
@end

@interface MHAddPersonCommand : NSObject <BNDCommand>
@property (nonatomic, readonly) id <MHCreator> creator;

+ (instancetype)commandWithCreator:(id <MHCreator> )creator;

@end
