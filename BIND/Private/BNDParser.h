//
//  BNDParser.h
//  BIND
//
//  Created by Marko Hlebar on 22/11/2014.
//  Copyright (c) 2014 Marko Hlebar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BNDBindingTypes.h"

@interface BNDBindingDefinition : NSObject
@property (nonatomic, strong) NSString *leftKeyPath;
@property (nonatomic, strong) NSString *rightKeyPath;
@property (nonatomic) BNDBindingDirection direction;
@property (nonatomic) BNDBindingTransformDirection transformDirection;
@property (nonatomic, strong) NSValueTransformer *valueTransformer;
@property (nonatomic) BOOL shouldSetInitialValues;
@end

@interface BNDParser : NSObject
+ (BNDBindingDefinition *)parseBIND:(NSString *)BIND;
@end
