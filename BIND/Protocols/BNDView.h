//
//  BNDView.h
//  BIND
//
//  Created by Marko Hlebar on 27/10/2014.
//  Copyright (c) 2014 Marko Hlebar. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BNDViewModel;
@protocol BNDView <NSObject>

/**
 *  View keeps a strong reference to the view model.
 */
@property (nonatomic, strong) id <BNDViewModel> viewModel;

@end
