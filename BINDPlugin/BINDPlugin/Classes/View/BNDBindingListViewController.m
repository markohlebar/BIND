//
//  BNDBindingListViewController.m
//  BINDPlugin
//
//  Created by Marko Hlebar on 29/11/2014.
//  Copyright (c) 2014 Marko Hlebar. All rights reserved.
//

#import "BNDBindingListViewController.h"
#import "NSTableView+BNDBinding.h"
#import "BNDBindingCellView.h"

@interface BNDBindingListViewController () <NSTableViewDataSource, NSTableViewDelegate>
@property (weak) IBOutlet NSTableView *tableView;
@property (nonatomic, strong) BNDBinding *reloadDataBinding;
@end

@implementation BNDBindingListViewController

static NSPanel *_panel;

+ (instancetype)presentInView:(NSView *)view {
    _panel = [[NSPanel alloc] initWithContentRect:NSMakeRect(0, 0, 400, 400)
                                        styleMask:NSClosableWindowMask
                                          backing:NSBackingStoreRetained
                                            defer:NO];
    
    BNDBindingListViewController *contentViewController = [[BNDBindingListViewController alloc] initWithNibName:nil bundle:[NSBundle bundleForClass:self]];
    
    [_panel setContentViewController:contentViewController];
    
    [[NSApp keyWindow] beginSheet:_panel
                completionHandler:^(NSModalResponse returnCode) {
                    
                }];
    
    return contentViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    [self loadBindings];
    
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSNib *nib = [[NSNib alloc] initWithNibNamed:@"BNDBindingCellView"
                                          bundle:bundle];
    [self.tableView registerNib:nib
                  forIdentifier:@"Cell"];
}

- (void)viewWillAppear {
    [self.dataController updateWithContext:nil
                         viewModelsHandler:^(NSArray *viewModels, NSError *error) {
                             self.viewModel = [viewModels firstObject];
                         }];
}

- (void)loadBindings {    
    self.reloadDataBinding = [BNDBinding bindingWithBIND:@"viewModel !-> tableView.onReloadData"];
    [self.reloadDataBinding bindLeft:self
                           withRight:self];
}

- (void)dealloc {
    [self.reloadDataBinding unbind];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    id <BNDTableSectionViewModel> viewModel = (id <BNDTableSectionViewModel>)self.viewModel;
    return viewModel.rowViewModels.count;
}

- (NSView *)tableView:(NSTableView *)tableView
   viewForTableColumn:(NSTableColumn *)tableColumn
                  row:(NSInteger)row {
    id view = [tableView makeViewWithIdentifier:@"Cell" owner:self];
    return view;
}

@end
