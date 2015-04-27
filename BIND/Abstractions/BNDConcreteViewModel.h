//
//  BNDConcreteViewModel.h
//  BIND
//
//  Created by Marko Hlebar on 22/04/2015.
//  Copyright (c) 2015 Marko Hlebar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BNDViewModel.h"

@interface BNDViewModel : NSObject <BNDViewModel>
@property (nonatomic, strong, readonly) id model;
@property (nonatomic, strong) NSArray *bindings;

- (instancetype)initWithModel:(id)model;
- (void)addSubViewModel:(BNDViewModel *)child;
- (void)removeSubViewModel:(BNDViewModel *)child;
- (void)removeAllSubViewModels;

@end
