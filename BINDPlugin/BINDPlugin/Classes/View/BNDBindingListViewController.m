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

@interface BNDBindingListViewController () <NSTableViewDataSource, NSTableViewDelegate, NSPopoverDelegate>
@property (weak) IBOutlet NSTableView *tableView;
@property (nonatomic, strong) BNDBinding *reloadDataBinding;
@property (nonatomic, strong) NSURL *xibURL;
@end

@implementation BNDBindingListViewController

static NSPanel *_panel;
static NSPopover *_popover;

+ (instancetype)presentWithXIBURL:(NSURL *)xibURL {
    NSView *view = [[NSApp keyWindow] contentView];
    BNDBindingListViewController *contentViewController = [[BNDBindingListViewController alloc] initWithNibName:nil bundle:[NSBundle bundleForClass:self]];
    contentViewController.xibURL = xibURL;
    
    _popover = [[NSPopover alloc] init];
    _popover.behavior = NSPopoverBehaviorTransient;
    _popover.appearance = [NSAppearance appearanceNamed:NSAppearanceNameVibrantLight];
    _popover.animates = NO;
    _popover.contentViewController = contentViewController;
    _popover.delegate = contentViewController;
    [_popover showRelativeToRect:NSMakeRect(400, 100, 400, 100)
                          ofView:view
                   preferredEdge:NSMinYEdge];
    
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
    __weak typeof(self) weakSelf = self;
    [self.dataController updateWithContext:self.xibURL
                         viewModelsHandler:^(NSArray *viewModels, NSError *error) {
                             weakSelf.viewModel = [viewModels firstObject];
                         }];
}

- (void)loadBindings {    
    self.reloadDataBinding = [BNDBinding bindingWithBIND:@"viewModel !-> tableView.onReloadData"];
    [self.reloadDataBinding bindLeft:self
                           withRight:self];
}

#pragma mark - NSTableViewDelegate / NSTableViewDataSource

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    id <BNDTableSectionViewModel> viewModel = (id <BNDTableSectionViewModel>)self.viewModel;
    return viewModel.rowViewModels.count;
}

- (NSView *)tableView:(NSTableView *)tableView
   viewForTableColumn:(NSTableColumn *)tableColumn
                  row:(NSInteger)row {
    BNDTableViewCell *view = [tableView makeViewWithIdentifier:@"Cell" owner:self];
    id <BNDTableSectionViewModel> viewModel = (id <BNDTableSectionViewModel>)self.viewModel;
    view.viewModel = viewModel.rowViewModels[row];
    return view;
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
    return 37;
}

#pragma mark - NSPopoverDelegate

- (void)popoverDidClose:(NSNotification *)notification {
    [self.reloadDataBinding unbind];
    
    NSRange range = [self.tableView rowsInRect:self.tableView.visibleRect];
    
    for (NSInteger row = range.location; row < range.location + range.length; row++) {
        BNDBindingCellView *cell = [self.tableView viewAtColumn:0
                                                            row:row
                                                makeIfNecessary:NO];
        [cell.bindings makeObjectsPerformSelector:@selector(unbind)];
    }
    
    _popover = nil;
}

- (void)dealloc {
    
}

@end
