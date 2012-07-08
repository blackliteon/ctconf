//
//  MainWindowController.m
//  demoapp
//
//  Created by Dmitry Nikolaev on 07.07.12.
//  Copyright (c) 2012 cocotype.com. All rights reserved.
//

#import "MainWindowController.h"
#import "TopPanelViewController.h"

@interface MainWindowController ()

@property (strong, nonatomic) TopPanelViewController *topPanelViewController;


@end

@implementation MainWindowController

@synthesize topPanelViewController = _topPanelViewController;

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

#pragma mark - Public

- (id)init {
    self = [super initWithWindowNibName:@"MainWindow"];
    if (self) {
        ;
    }
    return self;
}

- (void) loadWindow {
    [super loadWindow];
//    [self windowDidLoad];
}

- (void)windowDidLoad
{
    self.topPanelViewController = [[TopPanelViewController alloc] initWithNibName:@"TopPanelViewController" bundle:[NSBundle mainBundle]];

}

@end
