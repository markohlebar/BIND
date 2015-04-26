//
//  BNDViewModel.h
//  BIND
//
//  Created by Marko Hlebar on 27/10/2014.
//  Copyright (c) 2014 Marko Hlebar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@protocol BNDViewModel <NSObject>
@optional

/**
 *  Instantiate a new instance of the view model with a model.
 *
 *  @param model a model instance.
 *
 *  @return a view model instance.
 */
+ (instancetype)viewModelWithModel:(id)model;

/**
 *  A unique identifier for this view model. 
 *  In a situation where you need to differ between different view models,
 *  i.e. table view cells, use this identifier.
 *
 *  @return an identifier.
 */
- (NSString *)identifier;

@property (nonatomic, strong, readonly) NSArray *children;

@end

@protocol BNDTableViewModel <NSObject>
@property (nonatomic, strong, readonly) NSArray *sectionViewModels;
@end

@protocol BNDTableRowViewModel <BNDViewModel>
@optional

/**
 *  Cell height when used in table view.
 *
 *  @return cell height.
 */
- (CGFloat)cellHeight;

@end

@protocol BNDTableSectionViewModel <BNDTableRowViewModel>

@required

/**
 *  A collection of row view models.
 */
@property (nonatomic, strong, readonly) NSArray *rowViewModels;

@optional

/**
 *  A section title.
 */
@property (nonatomic, copy, readonly) NSString *title;

/**
 *  Class of the view to be represented as the section header in a table view.
 */
@property (nonatomic, copy, readonly) Class viewClass;

@end

@protocol BNDCollectionCellViewModel <BNDViewModel>

@optional

/**
 *  Cell size when used in collection view
 *
 *  @return cell size.
 */
- (CGSize)cellSize;

@end
