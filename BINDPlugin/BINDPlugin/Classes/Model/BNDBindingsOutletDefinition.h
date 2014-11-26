//
//  BNDBindingsOutletDefinition.h
//  BINDPlugin
//
//  Created by Marko Hlebar on 25/11/2014.
//  Copyright (c) 2014 Marko Hlebar. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const BNDBindingsOutletDefinitionXMLTemplate;

@interface BNDBindingsOutletDefinition : NSObject
@property (nonatomic, copy, readonly) NSString *ID;
@property (nonatomic, copy, readonly) NSString *bindingID;
@property (nonatomic, readonly) NSXMLElement *element;

+ (instancetype)definitionWithElement:(NSXMLElement *)element;
+ (instancetype)definitionWithID:(NSString *)ID
                       bindingID:(NSString *)bindingID;
@end
