//
//  BINDPlugin.m
//  BINDPlugin
//
//  Created by Marko Hlebar on 22/11/2014.
//  Copyright (c) 2014 Marko Hlebar. All rights reserved.
//

#import "BINDPlugin.h"
#import "MHXcodeDocumentNavigator.h"

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
            NSMenuItem *actionMenuItem = [[NSMenuItem alloc] initWithTitle:@"Do Action" action:@selector(doMenuAction) keyEquivalent:@""];
            [actionMenuItem setTarget:self];
            [[menuItem submenu] addItem:actionMenuItem];
        }
    }
    return self;
}

// Sample Action, for menu item:
- (void)doMenuAction
{
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setMessageText:@"Hello, World"];
    [alert runModal];
    
    NSURL *fileURL = [[MHXcodeDocumentNavigator currentInterfaceBuilderDocument] fileURL];
    NSString *string = [NSString stringWithContentsOfURL:fileURL
                                                encoding:NSUTF8StringEncoding
                                                   error:nil];
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
