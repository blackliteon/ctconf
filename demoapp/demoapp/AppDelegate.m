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
@property (strong, nonatomic) CTConfiguration *conf;

@end

@implementation AppDelegate

@synthesize conf = _conf; // todo: remove 
@synthesize mainWindowController = _mainWindowController;


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [[CTConfiguration sharedInstance] setConfFilePath:[NSString stringWithFormat:@"%@/demoapp.conf", NSHomeDirectory()]];
    
    BOOL development = YES;
    
    if (development) {
        MainScene *mainScene = [[MainScene alloc] init];
        SecondScene *secondScene = [[SecondScene alloc] init];
        [[CTConfiguration sharedInstance].sceneManager addScene:mainScene];
        [[CTConfiguration sharedInstance].sceneManager addScene:secondScene];
        [[CTConfiguration sharedInstance] startDevelopmentVersion];
    } else {
        [[CTConfiguration sharedInstance] startProductionVersion: YES];
        self.mainWindowController = [[MainWindowController alloc] init];
        [self.mainWindowController showWindow:self];
    }
    
    

    
    
}

@end
