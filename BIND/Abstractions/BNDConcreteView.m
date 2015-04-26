//
//  BNDConcreteView.m
//  BIND
//
//  Created by Marko Hlebar on 27/10/2014.
//  Copyright (c) 2014 Marko Hlebar. All rights reserved.
//

#import "BNDConcreteView.h"
#import "BNDBinding.h"

#define BND_VIEW_IMPLEMENTATION(__CLASS_NAME__) \
@implementation __CLASS_NAME__ \
BND_VIEW_IMPLEMENT_SET_VIEW_MODEL \
BND_VIEW_IMPLEMENT_VIEW_DID_UPDATE_VIEW_MODEL \
@end

BND_VIEW_IMPLEMENTATION(BNDTableViewCell)

BND_VIEW_IMPLEMENTATION(BNDView)

BND_VIEW_IMPLEMENTATION(BNDButton)

BND_VIEW_IMPLEMENTATION(BNDViewController)

#pragma mark - Platform Specific

#if TARGET_OS_IPHONE

BND_VIEW_IMPLEMENTATION(BNDCollectionViewCell)

#endif
