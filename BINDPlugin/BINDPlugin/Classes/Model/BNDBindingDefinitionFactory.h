//
//  BNDInterfaceBuilderIDProvider.h
//  BINDPlugin
//
//  Created by Marko Hlebar on 26/11/2014.
//  Copyright (c) 2014 Marko Hlebar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BNDBindingDefinition.h"
#import "BNDBindingsOutletDefinition.h"

extern NSString * const BNDBindingIDFormat;
extern NSString * const BNDBindingOutletIDFormat;

@interface BNDBindingDefinitionFactory : NSObject
@property (nonatomic, strong, readonly) NSArray *bindings;

+ (instancetype)factoryWithBindings:(NSArray *)bindings;

- (BNDBindingDefinition *)createBinding;
- (BNDBindingsOutletDefinition *)createBindingOutletWithBinding:(BNDBindingDefinition *)definition;

@end
