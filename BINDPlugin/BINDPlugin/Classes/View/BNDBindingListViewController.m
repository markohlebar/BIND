//
//  BNDBindingListViewController.m
//  BINDPlugin
//
//  Created by Marko Hlebar on 29/11/2014.
//  Copyright (c) 2014 Marko Hlebar. All rights reserved.
//

#import "BNDBindingListViewController.h"

@interface BNDBindingListViewController ()
@property (weak) IBOutlet NSTableView *tableView;
@end

@implementation BNDBindingListViewController

static NSPopover *_popover;

+ (instancetype)presentInView:(NSView *)view {
    if (_popover.isShown) {
        [_popover close];
        _popover = nil;
    }
    
    BNDBindingListViewController *contentViewController = [[BNDBindingListViewController alloc] initWithNibName:nil bundle:[NSBundle bundleForClass:self]];
    
    _popover = [[NSPopover alloc] init];
    _popover.behavior = NSPopoverBehaviorTransient;
    _popover.appearance = [NSAppearance appearanceNamed:NSAppearanceNameVibrantLight];
    _popover.animates = NO;
    _popover.contentViewController = contentViewController;
    [_popover showRelativeToRect:NSMakeRect(0, 0, 50, 50)
                         ofView:view
                  preferredEdge:NSMinYEdge];
    
    return contentViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    [self loadBindings];
}

- (void)viewWillAppear {
    [self.dataController updateWithContext:nil
                         viewModelsHandler:^(NSArray *viewModels, NSError *error) {
                             self.viewModel = [viewModels firstObject];
     }];
}

- (void)loadBindings {
    BNDBinding *binding = [BNDBinding bindingWithBIND:@"viewModel -> reloadData"];
    [binding bindLeft:self.viewModel
            withRight:self.tableView];
    self.bindings = [NSArray arrayWithObject:binding];
}

@end
