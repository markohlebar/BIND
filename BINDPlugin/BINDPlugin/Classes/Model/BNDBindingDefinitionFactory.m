//
//  BNDInterfaceBuilderIDProvider.m
//  BINDPlugin
//
//  Created by Marko Hlebar on 26/11/2014.
//  Copyright (c) 2014 Marko Hlebar. All rights reserved.
//

#import "BNDBindingDefinitionFactory.h"
#import <Foundation/NSXMLNode.h>

static NSString *BNDBindingIDFormat = @"binding-%d";
static NSString *BNDBindingOutletIDFormat = @"binding-out-%d";

@implementation BNDBindingDefinitionFactory {
    NSUInteger _ID;
}

+ (instancetype)providerWithXIBDocument:(NSXMLDocument *)xibDocument {
    return [[self alloc] initWithXIBDocument:xibDocument];
}

- (instancetype)initWithXIBDocument:(NSXMLDocument *)xibDocument {
    self = [super init];
    if (self) {
        _xibDocument = xibDocument;
        _ID = 0;
    }
    return self;
}

- (BNDBindingDefinition *)createBinding {
    return nil;
}

- (BNDBindingsOutletDefinition *)createBindingOutletWithBinding:(BNDBindingDefinition *)definition {
    return nil;
}

- (NSUInteger)createID {
    return ++_ID;
}

- (BOOL)containsNodeWithID:(NSString *)ID {
    return NO;
}

@end
