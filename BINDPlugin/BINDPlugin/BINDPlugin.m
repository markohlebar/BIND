//
//  BINDPlugin.m
//  BINDPlugin
//
//  Created by Marko Hlebar on 22/11/2014.
//  Copyright (c) 2014 Marko Hlebar. All rights reserved.
//

#import "BINDPlugin.h"
#import "MHXcodeDocumentNavigator.h"
#import "BNDBindingListViewController.h"

static BINDPlugin *sharedPlugin;

@interface BINDPlugin()

@property (nonatomic, strong, readwrite) NSBundle *bundle;
@end

@implementation BINDPlugin

+ (void)pluginDidLoad:(NSBundle *)plugin
{
    static dispatch_once_t onceToken;
    NSString *currentApplicationName = [[NSBundle mainBundle] infoDictionary][@"CFBundleName"];
    if ([currentApplicationName isEqual:@"Xcode"]) {
        dispatch_once(&onceToken, ^{
            sharedPlugin = [[self alloc] initWithBundle:plugin];
        });
    }
}

+ (instancetype)sharedPlugin
{
    return sharedPlugin;
}

- (id)initWithBundle:(NSBundle *)plugin
{
    if (self = [super init]) {
        // reference to plugin's bundle, for resource access
        self.bundle = plugin;
        
        // Create menu items, initialize UI, etc.

        // Sample Menu Item:
        NSMenuItem *menuItem = [[NSApp mainMenu] itemWithTitle:@"Edit"];
        if (menuItem) {
            [[menuItem submenu] addItem:[NSMenuItem separatorItem]];
            NSMenuItem *actionMenuItem = [[NSMenuItem alloc] initWithTitle:@"BIND" action:@selector(doMenuAction) keyEquivalent:@""];
            [actionMenuItem setTarget:self];
            [[menuItem submenu] addItem:actionMenuItem];
        }
    }
    return self;
}

// Sample Action, for menu item:
- (void)doMenuAction {
    NSURL *fileURL = [[MHXcodeDocumentNavigator currentInterfaceBuilderDocument] fileURL];
    
    if (!fileURL) {
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setAlertStyle:NSCriticalAlertStyle];
        [alert setMessageText:@"No XIB file selected."];
        [alert setInformativeText:@"Please select a XIB file you want to add bindings to."];
        [alert runModal];
    }
    else {
        
        
        NSView *canvasView = [MHXcodeDocumentNavigator currentInterfaceBuilderCanvasView];
        [BNDBindingListViewController presentWithXIBURL:fileURL];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
