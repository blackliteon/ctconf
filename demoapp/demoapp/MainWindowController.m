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
@property (strong, nonatomic) CTPushOnPushOffButton *pushIconButton;


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
    
    self.firstBgView = [[BGView alloc] initWithFrame:NSMakeRect(5, 5, self.window.frame.size.width - 10, 50)];
    
    self.bgColor = [[CTConfiguration sharedInstance] addStringProperty:@"app.bgColor" toObject:self key:@"bgColor" defaultValue:@"#ff0000"];
    
    [self.window.contentView addSubview:self.firstBgView];
    
    NSString *mainBundlePath = [[NSBundle mainBundle] bundlePath];

    self.momentaryButton = [[CTMomentaryButton alloc] initWithFrame:NSMakeRect(10, 100, 60, 60)];
    self.momentaryButton.delegate = self;
    NSString *buttonPath = [NSString stringWithFormat:@"%@/Contents/Resources/button", mainBundlePath];
    [self.momentaryButton setImagesFromPath:buttonPath sizeFromImageData:NO];
    [self.window.contentView addSubview:self.momentaryButton];

    self.pushOnPushOffButton = [[CTPushOnPushOffButton alloc] initWithFrame:NSMakeRect(100, 100, 60, 60)];
    self.pushOnPushOffButton.delegate = self;
    NSString *pushButtonPath = [NSString stringWithFormat:@"%@/Contents/Resources/pushbutton", mainBundlePath];
    [self.pushOnPushOffButton setImagesFromPath:pushButtonPath];
    [self.window.contentView addSubview:self.pushOnPushOffButton];
    
    // push button from template image
    
    NSString *circleButtonPath = [NSString stringWithFormat:@"%@/Contents/Resources/circle_template.png", mainBundlePath];
    NSImage *circleImageTpl = [[NSImage alloc] initWithContentsOfFile:circleButtonPath];
    NSImage *inactiveImg = [circleImageTpl tintedImageWithColor:[NSColor blackColor] backgroundColor:[NSColor whiteColor] opacity:0.75];
    NSImage *activeImg = [circleImageTpl tintedImageWithColor:[NSColor blueColor]];
    
    self.pushIconButton = [[CTPushOnPushOffButton alloc] initWithFrame:NSMakeRect(240, 140, 30, 30)];
    self.pushIconButton.pushedOffImage = inactiveImg;
    self.pushIconButton.pushedOnImage = activeImg;
    [self.window.contentView addSubview:self.pushIconButton];
    
    // rounded label
    
    CTRoundedLabelImageComposer *labelImageComposer = [[CTRoundedLabelImageComposer alloc] init];
    [labelImageComposer setText:@"Button with very long string"];
    NSImage *img = [labelImageComposer composeImage];
    
    if (!img) {
        NSLog(@"No image");
    }
    
    NSImageView *imgView = [[NSImageView alloc] initWithFrame:NSMakeRect(220, 50, img.size.width, img.size.height)];
    [imgView setImage:img];
    [self.window.contentView addSubview:imgView];
    
    // rounded button controller
    
    CTLabelButtonController *label = [[CTLabelButtonController alloc] initWithPropertyName:@"label" text:@"Label"];
    [label.button setFrameOrigin:NSMakePoint(150, 10)];
    [self.window.contentView addSubview:label.button];

}

#pragma mark - Button delegates

- (void) buttonClicked: (CTMomentaryButton *) button {
    NSLog(@"Momentary button clicked");
}

- (void) buttonStateChanged: (CTPushOnPushOffButton *) button {
    NSLog(@"Push button state changed to: %@", button.pushed ? @"ON" : @"OFF");
}


@end
