//
//  TopPanelViewController.m
//  demoapp
//
//  Created by Dmitry Nikolaev on 05.07.12.
//  Copyright (c) 2012 cocotype.com. All rights reserved.
//

#import "TopPanelViewController.h"
#import <ctconf/ctconf.h>
#import "BGView.h"

@interface TopPanelViewController () <CTPropertyListener>

@property (weak) IBOutlet NSButton *button1;
@property (weak) IBOutlet NSButton *button2;
@property (weak) IBOutlet NSButton *button3;
@property (weak) IBOutlet NSTextField *label;
@property (weak) IBOutlet BGView *bgView;

@property (assign, nonatomic) CGFloat topMargin;
@property (assign, nonatomic) CGFloat topPanelLeftMargin;
@property (assign, nonatomic) BOOL labelVisible;
@property (strong, nonatomic) NSString *bgColor;

@end

@implementation TopPanelViewController

@synthesize button1;
@synthesize button2;
@synthesize button3;
@synthesize label;
@synthesize bgView;

@synthesize topMargin = _topMargin;
@synthesize topPanelLeftMargin = _topPanelLeftMargin;
@synthesize labelVisible = _labelVisible;
@synthesize bgColor = _bgColor;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)dealloc {
    [[CTConfiguration sharedInstance] unregisterObjectFromUpdates:self];
}

- (void) loadView {
    [super loadView];
    
    self.topMargin = [[CTConfiguration sharedInstance] addDoubleProperty:@"topPanel.topMargin" toObject:self key:@"topMargin" defaultValue:3];

//    self.topPanelLeftMargin = [[CTConfiguration sharedInstance] addDoubleProperty:@"topPanel.leftMargin" toObject:self key:@"topPanelLeftMargin" defaultValue:20];
    
    self.topPanelLeftMargin = [[CTConfiguration sharedInstance] addDoubleProperty:@"topPanel.leftMargin" propertyListener:self defaultValue:20];
    
    self.labelVisible = [[CTConfiguration sharedInstance] addBooleanProperty:@"topPanel.labelVisible" toObject:self key:@"labelVisible" defaultValue:YES];
    
    self.bgColor = [[CTConfiguration sharedInstance] addStringProperty:@"app.bgColor" toObject:self key:@"bgColor" defaultValue:@"ff0000"];
    
}

- (void) setTopMargin:(CGFloat)topMargin {
    _topMargin = topMargin;
    
    CGFloat btnHeight = self.button1.frame.size.height; // all buttons have same height
    CGFloat containerHeight = self.view.bounds.size.height;
    CGFloat btnY = containerHeight - btnHeight - topMargin;
    
    CGFloat btn1x = self.button1.frame.origin.x;
    [self.button1 setFrameOrigin:NSMakePoint(btn1x, btnY)];
    
    CGFloat btn2x = self.button2.frame.origin.x;
    [self.button2 setFrameOrigin:NSMakePoint(btn2x, btnY)];
    
    CGFloat btn3x = self.button3.frame.origin.x;
    [self.button3 setFrameOrigin:NSMakePoint(btn3x, btnY)];
}

- (void) setTopPanelLeftMargin:(CGFloat)topPanelLeftMargin {
    _topPanelLeftMargin = topPanelLeftMargin;
    
    NSPoint btn1pt = self.button1.frame.origin;
    CGFloat additionalOffsetToLeft = btn1pt.x - topPanelLeftMargin;
    btn1pt.x = topPanelLeftMargin;
    [self.button1 setFrameOrigin:btn1pt];
    
    NSPoint btn2pt = self.button2.frame.origin;
    btn2pt.x -= additionalOffsetToLeft;
    [self.button2 setFrameOrigin:btn2pt];
    
    NSPoint btn3pt = self.button3.frame.origin;
    btn3pt.x -= additionalOffsetToLeft;
    [self.button3 setFrameOrigin:btn3pt];
    
}

- (void) setLabelVisible:(BOOL)labelVisible {
    [label setHidden:!labelVisible];
}

- (void) setBgColor:(NSString *)bgColor {
    self.bgView.bgColor = [NSColor colorFromHexRGB:bgColor];
}

- (void) propertyWithName: (NSString *) name updatedToValue: (id) value {
    if ([name isEqualToString:@"topPanel.leftMargin"]) {
        NSNumber *number = value;
        [self setTopPanelLeftMargin:[number doubleValue]];
    }
}


@end
