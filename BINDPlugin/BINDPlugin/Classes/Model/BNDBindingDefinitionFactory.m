//
//  BNDInterfaceBuilderIDProvider.m
//  BINDPlugin
//
//  Created by Marko Hlebar on 26/11/2014.
//  Copyright (c) 2014 Marko Hlebar. All rights reserved.
//

#import "BNDBindingDefinitionFactory.h"
#import "BNDBindingsOutletDefinition.h"

NSString * const BNDBindingIDFormat = @"binding-%ld";
NSString * const BNDBindingOutletIDSuffix = @"out-";
NSString * const BNDBindingOutletIDFormat = @"out-binding-%d";

@interface BNDBindingDefinitionFactory ()
@property (nonatomic, strong) NSMutableArray *mutableBindings;
@end

@implementation BNDBindingDefinitionFactory {
    NSInteger _ID;
}

+ (instancetype)factoryWithBindings:(NSArray *)bindings {
    return [[self alloc] initWithBindings:bindings];
}

- (instancetype)initWithBindings:(NSArray *)bindings {
    self = [super init];
    if (self) {
        _ID = 0;
        _mutableBindings = [[NSMutableArray alloc] initWithArray:bindings];
    }
    return self;
}

- (NSArray *)bindings {
    return self.mutableBindings.copy;
}

- (BNDBindingDefinition *)createBinding {
    NSString *ID = [self createID];
    BNDBindingDefinition *binding = [BNDBindingDefinition definitionWithID:ID
                                                                      BIND:@""];
    [self.mutableBindings addObject:binding];
    return binding;
}

- (BNDBindingsOutletDefinition *)createBindingOutletWithBinding:(BNDBindingDefinition *)definition {
    NSString *ID = [NSString stringWithFormat:@"%@%@", BNDBindingOutletIDSuffix, definition.ID];
    BNDBindingsOutletDefinition *outlet = [BNDBindingsOutletDefinition definitionWithID:ID bindingID:definition.ID];
    return outlet;
}

- (NSString *)createID {
    BOOL isNotUnique = YES;
    NSString *format = nil;
    while (isNotUnique) {
        format = [NSString stringWithFormat:BNDBindingIDFormat, (long)_ID];
        _ID++;
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ID = %@", format];
        NSArray *array = [self.bindings filteredArrayUsingPredicate:predicate];
        isNotUnique = array.count > 0 ? YES : NO;
    }

    return format;
}

- (BOOL)containsNodeWithID:(NSString *)ID {
    return NO;
}

@end
