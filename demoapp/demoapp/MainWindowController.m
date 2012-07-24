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
#import <ctconf/ctconf.h>

@interface MainWindowController () <CTMomentaryButtonDelegate, CTPushOnPushOffButtonDelegate>

@property (strong, nonatomic) TopPanelViewController *topPanelViewController;

@property (strong, nonatomic) BGView *firstBgView;
@property (strong, nonatomic) BGView *secondBgView;
@property (strong, nonatomic) CTMomentaryButton *momentaryButton;
@property (strong, nonatomic) CTPushOnPushOffButton *pushOnPushOffButton;

@property (strong, nonatomic) NSString *bgColor;

@end

@implementation MainWindowController

@synthesize topPanelViewController = _topPanelViewController;
@synthesize firstBgView = _firstBgView;
@synthesize secondBgView = _secondBgView;
@synthesize momentaryButton = _momentaryButton;
@synthesize pushOnPushOffButton = _pushOnPushOffButton;

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
    
    self.bgColor = [[CTConfiguration sharedInstance] addStringProperty:@"app.bgColor" toObject:self key:@"bgColor" defaultValue:@"#ff0000"];
    
    [self.window.contentView addSubview:self.firstBgView];
    
    NSString *mainBundlePath = [[NSBundle mainBundle] bundlePath];

    self.momentaryButton = [[CTMomentaryButton alloc] initWithFrame:NSMakeRect(160, 100, 60, 60)];
    self.momentaryButton.delegate = self;
    NSString *buttonPath = [NSString stringWithFormat:@"%@/Contents/Resources/button", mainBundlePath];
    [self.momentaryButton setImagesFromPath:buttonPath sizeFromImageData:NO];
    [self.window.contentView addSubview:self.momentaryButton];

    self.pushOnPushOffButton = [[CTPushOnPushOffButton alloc] initWithFrame:NSMakeRect(260, 100, 60, 60)];
    self.pushOnPushOffButton.delegate = self;
    NSString *pushButtonPath = [NSString stringWithFormat:@"%@/Contents/Resources/pushbutton", mainBundlePath];
    [self.pushOnPushOffButton setImagesFromPath:pushButtonPath];
    [self.window.contentView addSubview:self.pushOnPushOffButton];

}

#pragma mark - Button delegates

- (void) buttonClicked: (CTMomentaryButton *) button {
    NSLog(@"Momentary button clicked");
}

- (void) buttonStateChanged: (CTPushOnPushOffButton *) button {
    NSLog(@"Push button state changed to: %@", button.pushed ? @"ON" : @"OFF");
}


@end
