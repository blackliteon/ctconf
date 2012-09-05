//
//  AppDelegate.m
//  PushButtonDemo
//
//  Created by Dmitry Nikolaev on 05.09.12.
//  Copyright (c) 2012 Dmitry Nikolaev. All rights reserved.
//

#import "AppDelegate.h"
#import <ctconf/ctconf.h>

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{

    NSString *defaultConfPath = [[NSBundle mainBundle] pathForResource:@"pushbutton" ofType:@"conf"];
    NSLog(@"conf path: %@",defaultConfPath);
    [CTConfiguration sharedInstance].confFilePath = defaultConfPath;
    [CTConfiguration sharedInstance].mode = CTConfigurationMode;
    
    [[CTConfiguration sharedInstance] readConfig];
    [[CTConfiguration sharedInstance] showConfigurationPanel];
    
    // Insert code here to initialize your application
    CTPushOnPushOffButtonTemplateController *buttonController = [[CTPushOnPushOffButtonTemplateController alloc] initWithImageTemplatePathPropertyName:@"imageTemplatePath" stylesPropertyName:@"pushButtonStyles" backgroudColorProperty:nil];
    CGFloat xCenter = self.window.frame.size.width / 2 - buttonController.button.frame.size.width / 2;
    CGFloat yCenter = self.window.frame.size.height / 2 - buttonController.button.frame.size.height / 2;
    [buttonController.button setFrameOrigin:NSMakePoint(xCenter, yCenter)];
    [self.window.contentView addSubview:buttonController.button];
    
}

@end
