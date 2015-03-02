//
//  BNDConcreteView.h
//  BIND
//
//  Created by Marko Hlebar on 27/10/2014.
//  Copyright (c) 2014 Marko Hlebar. All rights reserved.
//

#import "BNDView.h"
#import "BNDMacros.h"

@class BNDBinding;

/**
 *  BNDTableViewCell is concrete table view cell subclass that loads bindings
 *  from a XIB and then refreshes the bindings when the 
 *  cell gets updated. 
 *  It also synthesizes your viewModel property.
 *  The user of this cell should call setViewModel:
 *  in UITableViewDelegate's tableView:cellForRowAtIndexPath: method
 *  so that the bindings get updated.
 */
@interface BNDTableViewCell : _BNDTableViewCell <BNDView>
@property (nonatomic, strong) IBOutletCollection(BNDBinding) NSArray *bindings;
@end

/**
 *  BNDView is an concrete view subclass that loads bindings
 *  from a XIB and then refreshes the bindings when the
 *  cell gets updated.
 *  It also synthesizes your viewModel property.
 *  The user of this view should call setViewModel:
 *  so that the bindings get updated.
 */
@interface BNDView : _BNDView <BNDView>
@property (nonatomic, strong) IBOutletCollection(BNDBinding) NSArray *bindings;
@end

/**
 *  BNDButton is an concrete button subclass that loads bindings
 *  from a XIB and then refreshes the bindings when the
 *  cell gets updated.
 *  It also synthesizes your viewModel property.
 *  The user of this view should call setViewModel:
 *  so that the bindings get updated.
 */
@interface BNDButton : _BNDButton <BNDView>
@property (nonatomic, strong) IBOutletCollection(BNDBinding) NSArray *bindings;
@end

/**
 *  BNDViewController is a concrete view controller subclass that loads bindings
 *  from a XIB and then refreshes the bindings when the
 *  cell gets updated.
 *  It also synthesizes your viewModel property.
 *  The user of this view controller should call setViewModel:
 *  so that the bindings get updated.
 */
@interface BNDViewController : _BNDViewController <BNDViewController>
@property (nonatomic, strong) IBOutletCollection(BNDBinding) NSArray *bindings;
@property (nonatomic, strong) IBOutlet id <BNDDataController> dataController;
@end


#pragma mark - Platform Specific

#if TARGET_OS_IPHONE

/**
 *  BNDCollectionViewCell is a concrete collection view cell subclass that loads bindings
 *  from a XIB and then refreshes the bindings when the
 *  cell gets updated.
 *  It also synthesizes your viewModel property.
 *  The user of this cell should call setViewModel:
 *  in UICollectionViewDelegate's collectionView:cellForItemAtIndexPath: method
 *  so that the bindings get updated.
 */
@interface BNDCollectionViewCell : UICollectionViewCell <BNDView>
@property (nonatomic, strong) IBOutletCollection(BNDBinding) NSArray *bindings;
@end

#endif
