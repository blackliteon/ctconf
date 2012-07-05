//
//  AppDelegate.m
//  demoapp
//
//  Created by Dmitry Nikolaev on 04.07.12.
//  Copyright (c) 2012 cocotype.com. All rights reserved.
//

#import "AppDelegate.h"
#import <ctconf/ctconf.h>
#import "TopPanelViewController.h"

@interface AppDelegate ()

@property (strong, nonatomic) TopPanelViewController *topPanelViewController;
@property (strong, nonatomic) CTConfiguration *conf;

@end

@implementation AppDelegate

@synthesize window = _window;
@synthesize topPanelViewController = _topPanelViewController;
@synthesize conf = _conf;

- (void) setTopPanelViewController:(TopPanelViewController *)topPanelViewController {
    _topPanelViewController = topPanelViewController;
    [self.topPanelViewController ctconfInit:self.conf];
    [self.window.contentView addSubview:self.topPanelViewController.view];

    // place top panel to top
    
    CGFloat topPanelHeight = self.topPanelViewController.view.frame.size.height;
    NSView *contentView = self.window.contentView;
    CGFloat containerHeight = contentView.frame.size.height;
    [self.topPanelViewController.view setFrameOrigin:NSMakePoint(0, containerHeight - topPanelHeight)];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.conf = [[CTConfiguration alloc] init];
    
    self.topPanelViewController = [[TopPanelViewController alloc] init];
    
}

@end
