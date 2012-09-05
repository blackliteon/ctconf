//
//  AppDelegate.m
//  LabelButtonDemo
//
//  Created by Dmitry Nikolaev on 05.09.12.
//  Copyright (c) 2012 Dmitry Nikolaev. All rights reserved.
//

#import "AppDelegate.h"
#import <ctconf/ctconf.h>

@interface AppDelegate ()

@property (strong, nonatomic) CTMomentaryButtonWithLabelController *buttonController;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    
    NSString *defaultConfPath = [[NSBundle mainBundle] pathForResource:@"labelbutton" ofType:@"conf"];
    [CTConfiguration sharedInstance].confFilePath = defaultConfPath;
    [CTConfiguration sharedInstance].mode = CTConfigurationMode;
    
    [[CTConfiguration sharedInstance] readConfig];
    [[CTConfiguration sharedInstance] showConfigurationPanel];
    
    // Insert code here to initialize your application
    self.buttonController = [[CTMomentaryButtonWithLabelController alloc] initWithPropertyName:@"buttonStyles" text:@"Label"];
    [self.window.contentView addSubview:self.buttonController.button];
    [self _centerButton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(buttonFrameUpdated:) name:NSViewFrameDidChangeNotification object:self.buttonController.button];
    
}

- (void) _centerButton {
    CGFloat xCenter = (int)(self.window.frame.size.width / 2 - self.buttonController.button.frame.size.width / 2);
    CGFloat yCenter = (int)(self.window.frame.size.height / 2 - self.buttonController.button.frame.size.height / 2);
    [self.buttonController.button setFrameOrigin:NSMakePoint(xCenter, yCenter)];
}

- (void) buttonFrameUpdated: (NSNotification *) notification {
    [self _centerButton];
}


@end
