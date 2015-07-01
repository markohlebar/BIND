//
//  BNDConcreteView.m
//  BIND
//
//  Created by Marko Hlebar on 27/10/2014.
//  Copyright (c) 2014 Marko Hlebar. All rights reserved.
//

#import "BNDConcreteView.h"

BND_VIEW_IMPLEMENTATION(BNDTableViewCell)

BND_VIEW_IMPLEMENTATION(BNDView)

BND_VIEW_IMPLEMENTATION(BNDButton)

BND_VIEW_IMPLEMENTATION(BNDViewController)

#pragma mark - Platform Specific

#if TARGET_OS_IPHONE

BND_VIEW_IMPLEMENTATION(BNDCollectionViewCell)

BND_VIEW_IMPLEMENTATION(BNDCollectionReusableView)

#endif
