//
//  AppDelegate.m
//  demoapp
//
//  Created by Dmitry Nikolaev on 04.07.12.
//  Copyright (c) 2012 cocotype.com. All rights reserved.
//

#import "AppDelegate.h"
#import <ctconf/ctconf.h>
#import "TopPanelViewController.h"
#import "MainWindowController.h"
#import "MainScene.h"
#import "SecondScene.h"

@interface AppDelegate ()

@property (strong, nonatomic) MainWindowController *mainWindowController;

@end

@implementation AppDelegate

@synthesize mainWindowController = _mainWindowController;


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{

    NSString *defaultConfPath = [[NSBundle mainBundle] pathForResource:@"demoapp" ofType:@"conf"];
    NSString *confPath = defaultConfPath;
    CTMode mode = CTNormalMode;
    
    NSArray *arguments = [[NSProcessInfo processInfo] arguments];
    for (int i = 0; i < arguments.count; i++) {
        NSString *currentArg = [arguments objectAtIndex:i];
        if ([currentArg isEqualToString:@"-ctconfpath"] && arguments.count > (i+1)) {
            confPath = [arguments objectAtIndex:i+1];
        }
        
        if ([currentArg isEqualToString:@"-ctconfmode"]) {
            mode = CTConfigurationMode;
        }
    }

    if (mode == CTConfigurationMode && confPath == defaultConfPath) {
        NSLog(@"Warning: to start configuration mode specify -ctconfpath outside of the main bundle.");
        mode  = CTNormalMode;
    }
    
    [CTConfiguration sharedInstance].confFilePath = confPath;
    [CTConfiguration sharedInstance].mode = mode;
    
    if (mode == CTNormalMode) {
        
        [[CTConfiguration sharedInstance] readConfig];
        self.mainWindowController = [[MainWindowController alloc] init];
        [self.mainWindowController showWindow:self];
        
    } else {
        
        [[CTConfiguration sharedInstance] readConfig];
        
        MainScene *mainScene = [[MainScene alloc] init];
        SecondScene *secondScene = [[SecondScene alloc] init];
        [[CTConfiguration sharedInstance].sceneManager addScene:mainScene];
        [[CTConfiguration sharedInstance].sceneManager addScene:secondScene];

        [[CTConfiguration sharedInstance] showConfigurationPanel];
    }
    
}

@end
