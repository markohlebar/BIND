//
//  BNDConcreteView.h
//  BIND
//
//  Created by Marko Hlebar on 27/10/2014.
//  Copyright (c) 2014 Marko Hlebar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BNDView.h"

@class BNDBinding;

/**
 *  BNDTableViewCell is concrete table view cell subclass that loads bindings
 *  from a XIB and then refreshes the bindings when the 
 *  cell gets updated. 
 *  The user of this cell should call setViewModel:
 *  in UITableViewDelegate's tableView:cellForRowAtIndexPath: method
 *  so that the bindings get updated.
 */
@interface BNDTableViewCell : UITableViewCell <BNDView>
@property (nonatomic, strong) IBOutletCollection(BNDBinding) NSArray *bindings;
@end

/**
 *  BNDCollectionViewCell is a concrete collection view cell subclass that loads bindings
 *  from a XIB and then refreshes the bindings when the
 *  cell gets updated.
 *  The user of this cell should call setViewModel:
 *  in UITableViewDelegate's tableView:cellForRowAtIndexPath: method
 *  so that the bindings get updated.
 */
@interface BNDCollectionViewCell : UICollectionViewCell <BNDView>
@property (nonatomic, strong) IBOutletCollection(BNDBinding) NSArray *bindings;
@end

/**
 *  BNDView is an concrete view subclass that loads bindings
 *  from a XIB and then refreshes the bindings when the
 *  cell gets updated.
 *  The user of this cell should call setViewModel:
 *  in UITableViewDelegate's tableView:cellForRowAtIndexPath: method
 *  so that the bindings get updated.
 */
@interface BNDView : UIView <BNDView>
@property (nonatomic, strong) IBOutletCollection(BNDBinding) NSArray *bindings;
@end

/**
 *  BNDViewController is a concrete view controller subclass that loads bindings
 *  from a XIB and then refreshes the bindings when the
 *  cell gets updated.
 *  The user of this cell should call setViewModel:
 *  in UITableViewDelegate's tableView:cellForRowAtIndexPath: method
 *  so that the bindings get updated.
 */
@interface BNDViewController : UIViewController <BNDView>
@property (nonatomic, strong) IBOutletCollection(BNDBinding) NSArray *bindings;
@end
