//
//  BNDInterfaceBuilderIDProvider.h
//  BINDPlugin
//
//  Created by Marko Hlebar on 26/11/2014.
//  Copyright (c) 2014 Marko Hlebar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNDInterfaceBuilderIDProvider : NSObject
@property (nonatomic, strong, readonly) NSXMLDocument *xibDocument;

+ (instancetype)providerWithXIBDocument:(NSXMLDocument *)xibDocument;
- (NSString *)createBindingID;
- (NSString *)createBindingOutletID;

@end
