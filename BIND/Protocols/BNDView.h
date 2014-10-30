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
 *  Update the view with fresh view model.
 *
 *  @param viewModel a view model.
 */
- (void)updateWithViewModel:(id <BNDViewModel> )viewModel;

@end
