//
//  AppDelegate.m
//  Horizontal Container Demo
//
//  Created by Dmitry Nikolaev on 15.10.12.
//  Copyright (c) 2012 Cocotype. All rights reserved.
//

#import "AppDelegate.h"
#import <ctconf/ctconf.h>

@interface AppDelegate ()

@property (strong, nonatomic) CTHorizontalContainerViewController *containerController;

@end


@implementation AppDelegate

#define CONTAINER_HEIGHT 80

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    NSString *defaultConfPath = [[NSBundle mainBundle] pathForResource:@"panel" ofType:@"conf"];
    [CTConfiguration sharedInstance].confFilePath = defaultConfPath;
    [CTConfiguration sharedInstance].mode = CTConfigurationMode;
    
    [[CTConfiguration sharedInstance] readConfig];
    [[CTConfiguration sharedInstance] showConfigurationPanel];

    // Insert code here to initialize your application
    
    self.containerController = [[CTHorizontalContainerViewController alloc] initWithPropertyName:@"horizontalContainer"];
    [self.containerController.containerView setAutoresizingMask:NSViewMinYMargin | NSViewMaxYMargin | NSViewWidthSizable];
    CGFloat y = self.window.frame.size.height / 2 - CONTAINER_HEIGHT / 2;
    [self.containerController.containerView setFrame:NSMakeRect(0, (int)y, self.window.frame.size.width, CONTAINER_HEIGHT)];
    [self.window.contentView addSubview:self.containerController.containerView];
    
    // add elements of container
    
    CTLabelButtonController *labelController1 = [[CTLabelButtonController alloc] initWithPropertyName:@"labelStyle" text:@"button"];
    [self.containerController.containerView addItem:labelController1.button];

    CTLabelButtonController *labelController2 = [[CTLabelButtonController alloc] initWithPropertyName:@"labelStyle" text:@"button"];
    [self.containerController.containerView addRightItem:labelController2.button];
}

@end
