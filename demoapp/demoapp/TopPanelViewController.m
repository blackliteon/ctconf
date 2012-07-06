//
//  TopPanelViewController.m
//  demoapp
//
//  Created by Dmitry Nikolaev on 05.07.12.
//  Copyright (c) 2012 cocotype.com. All rights reserved.
//

#import "TopPanelViewController.h"
#import <ctconf/ctconf.h>

@interface TopPanelViewController ()

@property (weak) IBOutlet NSButton *button1;
@property (weak) IBOutlet NSButton *button2;
@property (weak) IBOutlet NSButton *button3;

@property (assign, nonatomic) CGFloat topMargin;
@property (assign, nonatomic) CGFloat leftMargin;

@end

@implementation TopPanelViewController

@synthesize button1;
@synthesize button2;
@synthesize button3;

@synthesize topMargin = _topMargin;
@synthesize leftMargin = _leftMargin;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void) loadView {
    [super loadView];
    self.topMargin = [[CTConfiguration sharedInstance] declareCGFloatPropertyInObject:self withName:@"topPanel.topMargin" defaultValue:3];
    self.leftMargin = [[CTConfiguration sharedInstance] declareCGFloatPropertyInObject:self withName:@"topPanel.leftMargin" defaultValue:0];
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

- (void) setLeftMargin:(CGFloat)leftMargin {
    _leftMargin = leftMargin;
    
    NSPoint btn1pt = self.button1.frame.origin;
    CGFloat additionalOffsetToLeft = btn1pt.x - leftMargin;
    btn1pt.x = leftMargin;
    [self.button1 setFrameOrigin:btn1pt];
    
    NSPoint btn2pt = self.button2.frame.origin;
    btn2pt.x -= additionalOffsetToLeft;
    [self.button2 setFrameOrigin:btn2pt];
    
    NSPoint btn3pt = self.button3.frame.origin;
    btn3pt.x -= additionalOffsetToLeft;
    [self.button3 setFrameOrigin:btn3pt];
    
}



@end
