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
#import "BNDBindingCreateCellView.h"
#import "BNDBindingListDataController.h"

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
}

- (void)viewWillAppear {
    __weak typeof(self) weakSelf = self;
    [self.dataController updateWithContext:self.xibURL
                         viewModelsHandler:^(NSArray *viewModels, NSError *error) {
                             weakSelf.viewModel = [viewModels firstObject];
                         }];
}

- (void)loadBindings {    
    BNDBinding *binding = [BNDBinding bindingWithBIND:@"viewModel ~> tableView.onReloadData"];
    self.bindings = [NSArray arrayWithObject:binding];
}

#pragma mark - NSTableViewDelegate / NSTableViewDataSource

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    id <BNDTableSectionViewModel> viewModel = (id <BNDTableSectionViewModel>)self.viewModel;
    return viewModel.rowViewModels.count;
}

- (NSView *)tableView:(NSTableView *)tableView
   viewForTableColumn:(NSTableColumn *)tableColumn
                  row:(NSInteger)row {
    id <BNDTableSectionViewModel> viewModel = (id <BNDTableSectionViewModel>)self.viewModel;
    id <BNDTableRowViewModel> rowViewModel = viewModel.rowViewModels[row];
    
    NSString *className = [rowViewModel identifier];
    BNDTableViewCell *cell = [tableView makeViewWithIdentifier:className
                                                         owner:self];
    if (!cell) {
        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        NSArray *topLevelObjects = nil;
        [bundle loadNibNamed:className
                       owner:self
             topLevelObjects:&topLevelObjects];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF isKindOfClass:%@", NSClassFromString(className)];
        cell = [[topLevelObjects filteredArrayUsingPredicate:predicate] firstObject];
        [cell setIdentifier:className];
    }
    cell.viewModel = rowViewModel;
    return cell;
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
    return 37;
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification {
    if (self.tableView.selectedRow == -1) {
        return;
    }

    BNDBindingCellView *cell = [self.tableView viewAtColumn:self.tableView.selectedColumn
                                                        row:self.tableView.selectedRow
                                            makeIfNecessary:NO];
    if ([cell isKindOfClass:[BNDBindingCellView class]]) {
        [cell.textField becomeFirstResponder];
    }
    else if ([cell isKindOfClass:[BNDBindingCreateCellView class]]) {
        [self makeCellFirstResponderAtRow:self.tableView.selectedRow
                               afterDelay:0.01];
        
        BNDBindingListDataController *dataController = self.dataController;
        [dataController createBinding];
    }
    
    [self.tableView deselectRow:self.tableView.selectedRow];
}

- (void)makeCellFirstResponderAtRow:(NSInteger)row
                         afterDelay:(NSTimeInterval)delay {
    if (row < 0) {
        return;
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        BNDBindingCellView *cell = [self.tableView viewAtColumn:0
                                                            row:row
                                                makeIfNecessary:NO];
        if ([cell isKindOfClass:[BNDBindingCellView class]]) {
            [cell.textField becomeFirstResponder];
            cell.textField.placeholderString = @"modelView.text ~> model.text";
        }
    });
}

- (void)popoverDidClose:(NSNotification *)notification {
    BNDBindingListDataController *dataController = self.dataController;
    [dataController write];
    
    _popover = nil;
}

@end
