//
//  BNDParser.h
//  BIND
//
//  Created by Marko Hlebar on 22/11/2014.
//  Copyright (c) 2014 Marko Hlebar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BNDBindingTypes.h"

@interface BNDBindingModel : NSObject
@property (nonatomic, copy) NSString *leftKeyPath;
@property (nonatomic, copy) NSString *rightKeyPath;
@property (nonatomic) BNDBindingDirection direction;
@property (nonatomic) BNDBindingTransformDirection transformDirection;
@property (nonatomic, strong) NSValueTransformer *valueTransformer;
@property (nonatomic) BOOL shouldSetInitialValues;
@property (nonatomic, copy) NSString *operator;
@end

@interface BNDParser : NSObject
+ (BNDBindingModel *)parseBIND:(NSString *)BIND;
@end
