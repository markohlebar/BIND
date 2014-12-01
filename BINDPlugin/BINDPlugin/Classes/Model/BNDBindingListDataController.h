//
//  BNDBindingListDataController.h
//  BINDPlugin
//
//  Created by Marko Hlebar on 29/11/2014.
//  Copyright (c) 2014 Marko Hlebar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BIND.h"

@class BNDBindingDefinitionFactory;
@class BNDInterfaceBuilderWriter;
@interface BNDBindingListDataController : NSObject <BNDDataController>
@property (nonatomic, strong) BNDBindingDefinitionFactory *bindingFactory;
@property (nonatomic, strong) BNDInterfaceBuilderWriter *bindingWriter;

- (void)createBinding;

@end
