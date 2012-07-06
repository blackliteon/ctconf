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

@end

@implementation TopPanelViewController

@synthesize button1;
@synthesize button2;
@synthesize button3;

@synthesize topMargin = _topMargin;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
        self.topMargin = [[CTConfiguration sharedInstance] declareCGFloatPropertyInObject:self withName:@"topPanel.topMargin" defaultValue:3];
    }
    
    return self;
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



@end
