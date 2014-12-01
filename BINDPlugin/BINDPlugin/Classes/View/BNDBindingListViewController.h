//
//  BNDBindingListViewController.h
//  BINDPlugin
//
//  Created by Marko Hlebar on 29/11/2014.
//  Copyright (c) 2014 Marko Hlebar. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "BIND.h"

@interface BNDBindingListViewController : BNDViewController

+ (instancetype)presentWithXIBURL:(NSURL *)xibURL;

@end
