//
//  BNDView.h
//  BIND
//
//  Created by Marko Hlebar on 27/10/2014.
//  Copyright (c) 2014 Marko Hlebar. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BNDBinding;
@protocol BNDViewModel;
@protocol BNDView <NSObject>

/**
 *  This is an a bindings collection used to add bindings from XIB
 */
@property (nonatomic, strong) IBOutletCollection(BNDBinding) NSArray *bindings;

/**
 *  View keeps a strong reference to the view model.
 */
@property (nonatomic, strong) IBOutlet id <BNDViewModel> viewModel;

@optional

/**
 *  Callback method that is called after the view model has been updated.
 *
 *  @param viewModel a view model.
 */
- (void)viewDidUpdateViewModel:(id <BNDViewModel> )viewModel;

@end

@protocol BNDDataController;
@protocol BNDViewController <BNDView>

@optional

/**
 *  The data controller instance should be used to populate your view models.
 */
@property (nonatomic, strong) IBOutlet id <BNDDataController> dataController;

@end
