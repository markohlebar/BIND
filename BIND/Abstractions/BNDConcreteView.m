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
@synthesize viewModel = _viewModel; \
- (void)setViewModel:(id <BNDViewModel> )viewModel { \
    for (BNDBinding *binding in self.bindings) { \
        if ([self isShorthandBinding:binding]) { \
            [binding bindLeft:viewModel withRight:self]; \
        } \
        else { \
            [binding bindLeft:self withRight:self]; \
        } \
    } \
    [self willChangeValueForKey:@"viewModel"]; \
    _viewModel = viewModel; \
    [self didChangeValueForKey:@"viewModel"]; \
    [self viewDidUpdateViewModel:viewModel]; \
} \
- (BOOL)isShorthandBinding:(BNDBinding *)binding { \
    return [binding.BIND rangeOfString:@"viewModel"].location == NSNotFound; \
} \
- (void)viewDidUpdateViewModel:(id <BNDViewModel> )viewModel { \
} \
@end

BND_VIEW_IMPLEMENTATION(BNDTableViewCell)

BND_VIEW_IMPLEMENTATION(BNDView)

BND_VIEW_IMPLEMENTATION(BNDButton)

BND_VIEW_IMPLEMENTATION(BNDViewController)

#pragma mark - Platform Specific

#if TARGET_OS_IPHONE

BND_VIEW_IMPLEMENTATION(BNDCollectionViewCell)

#endif
