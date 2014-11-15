//
//  BNDDataController.h
//  BIND
//
//  Created by Marko Hlebar on 14/11/2014.
//  Copyright (c) 2014 Marko Hlebar. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^BNDViewModelsBlock)(NSArray *viewModels, NSError *error);

@protocol BNDDataController <NSObject>

/**
 *  The data controller should be responsible for transforming the model to view model,
 *  and returning it back to the view.
 *
 *  @param context           a context.
 *  @param viewModelsHandler view models handler block.
 */
- (void)updateWithContext:(id)context
        viewModelsHandler:(BNDViewModelsBlock)viewModelsHandler;

@end
