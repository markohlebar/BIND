//
//  BNDBindingDefinition.h
//  BINDPlugin
//
//  Created by Marko Hlebar on 23/11/2014.
//  Copyright (c) 2014 Marko Hlebar. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const BNDBindingDefinitionXMLTemplate;

@interface BNDBindingDefinition : NSObject
@property (nonatomic, copy, readonly) NSString *ID;
@property (nonatomic, copy, readonly) NSString *BIND;
@property (nonatomic, readonly) NSXMLElement *element;

+ (instancetype)definitionWithElement:(NSXMLElement *)element;
+ (instancetype)definitionWithID:(NSString *)ID
                            BIND:(NSString *)BIND;

@end
