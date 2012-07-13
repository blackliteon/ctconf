//
//  MainWindowController.m
//  demoapp
//
//  Created by Dmitry Nikolaev on 07.07.12.
//  Copyright (c) 2012 cocotype.com. All rights reserved.
//

#import "MainWindowController.h"
#import "TopPanelViewController.h"
#import "BGView.h"
#import "NSColor+FromHex.h"
#import <ctconf/ctconf.h>

@interface MainWindowController ()

@property (strong, nonatomic) TopPanelViewController *topPanelViewController;

@property (strong, nonatomic) BGView *firstBgView;
@property (strong, nonatomic) BGView *secondBgView;

@property (strong, nonatomic) NSString *bgColor;

@end

@implementation MainWindowController

@synthesize topPanelViewController = _topPanelViewController;
@synthesize firstBgView = _firstBgView;
@synthesize secondBgView = _secondBgView;
@synthesize bgColor = _bgColor;

- (void) setTopPanelViewController:(TopPanelViewController *)topPanelViewController {
    
    NSWindow *window = self.window;
    
    _topPanelViewController = topPanelViewController;
    [window.contentView addSubview:self.topPanelViewController.view];
    
    // place top panel to top
    
    CGFloat topPanelHeight = self.topPanelViewController.view.frame.size.height;
    NSView *contentView = window.contentView;
    CGFloat containerHeight = contentView.frame.size.height;
    [self.topPanelViewController.view setFrameOrigin:NSMakePoint(0, containerHeight - topPanelHeight)];
}

- (void) setBgColor:(NSString *)bgColor {
    self.firstBgView.bgColor = [NSColor colorFromHexRGB:bgColor];
}

#pragma mark - Public

- (id)init {
    self = [super initWithWindowNibName:@"MainWindow"];
    if (self) {
        ;
    }
    return self;
}

- (void)dealloc {
    [[CTConfiguration sharedInstance] unregisterObjectFromUpdates:self];
}

- (void) loadWindow {
    [super loadWindow];
}

- (void)windowDidLoad
{
    self.topPanelViewController = [[TopPanelViewController alloc] initWithNibName:@"TopPanelViewController" bundle:[NSBundle mainBundle]];
    
    self.firstBgView = [[BGView alloc] initWithFrame:NSMakeRect(20, 20, 100, 100)];
    
//    self.bgColor = [[CTConfiguration sharedInstance] addStringProperty:@"app.bgColor" toObject:self key:@"bgColor" defaultValue:@"ff0000"];
    self.bgColor = [[CTConfiguration sharedInstance] addStringProperty:@"app.bgColor" toObject:self key:@"bgColor" defaultValue:@"#ff0000"];
    
    [self.window.contentView addSubview:self.firstBgView];

}

@end
