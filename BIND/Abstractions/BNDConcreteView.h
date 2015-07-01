//
//  BNDConcreteView.h
//  BIND
//
//  Created by Marko Hlebar on 27/10/2014.
//  Copyright (c) 2014 Marko Hlebar. All rights reserved.
//

#import "BNDView.h"
#import "BNDMacros.h"

/**
 *  BNDTableViewCell is concrete table view cell subclass that loads bindings
 *  from a XIB and then refreshes the bindings when the 
 *  cell gets updated. 
 *  It also synthesizes your viewModel property.
 *  The user of this cell should call setViewModel:
 *  in UITableViewDelegate's tableView:cellForRowAtIndexPath: method
 *  so that the bindings get updated.
 */
BND_VIEW_INTERFACE(BNDTableViewCell, _BNDTableViewCell)

/**
 *  BNDView is an concrete view subclass that loads bindings
 *  from a XIB and then refreshes the bindings when the
 *  cell gets updated.
 *  It also synthesizes your viewModel property.
 *  The user of this view should call setViewModel:
 *  so that the bindings get updated.
 */
BND_VIEW_INTERFACE(BNDView, _BNDView)

/**
 *  BNDButton is an concrete button subclass that loads bindings
 *  from a XIB and then refreshes the bindings when the
 *  cell gets updated.
 *  It also synthesizes your viewModel property.
 *  The user of this view should call setViewModel:
 *  so that the bindings get updated.
 */
BND_VIEW_INTERFACE(BNDButton, _BNDButton)

/**
 *  BNDViewController is a concrete view controller subclass that loads bindings
 *  from a XIB and then refreshes the bindings when the
 *  cell gets updated.
 *  It also synthesizes your viewModel property.
 *  The user of this view controller should call setViewModel:
 *  so that the bindings get updated.
 */
@interface BNDViewController : _BNDViewController <BNDView> {
    NSArray *_bindings;
}
@property (nonatomic, strong) IBOutlet id <BNDDataController> dataController;
@property (nonatomic, strong) IBOutletCollection(BNDBinding) NSArray *bindings;
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
BND_VIEW_INTERFACE(BNDCollectionViewCell, UICollectionViewCell)

/**
 *  BNDCollectionReusableView is a concrete collection reusable view subclass that loads bindings
 *  from a XIB and then refreshes the bindings when the
 *  cell gets updated.
 *  It also synthesizes your viewModel property.
 *  The user of this view should call setViewModel:
 *  in UICollectionViewDelegate's collectionView:viewForSupplementaryElementOfKind:atIndexPath: method
 *  so that the bindings get updated.
 */
BND_VIEW_INTERFACE(BNDCollectionReusableView, UICollectionReusableView)

#endif
