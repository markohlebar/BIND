//
//  BNDViewModel.h
//  BIND
//
//  Created by Marko Hlebar on 27/10/2014.
//  Copyright (c) 2014 Marko Hlebar. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BNDViewModel <NSObject>

/**
 *  Instantiate a new instance of the view model with a model.
 *
 *  @param model a model instance.
 *
 *  @return a view model instance.
 */
+ (instancetype)viewModelWithModel:(id)model;
@required

/**
 *  A unique identifier for this view model. 
 *  In a situation where you need to differ between different view models,
 *  i.e. table view cells, use this identifier.
 *
 *  @return an identifier.
 */
- (NSString *)identifier;
@end

@protocol BNDTableViewModel <BNDViewModel>
@required
- (CGFloat)cellHeight;
@end

@protocol BNDCollectionViewModel <BNDViewModel>
@required
- (CGSize)cellSize;
@end