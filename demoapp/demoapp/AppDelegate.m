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

@interface AppDelegate ()

@property (strong, nonatomic) MainWindowController *mainWindowController;
@property (strong, nonatomic) CTConfiguration *conf;

@end

@implementation AppDelegate

@synthesize conf = _conf; // todo: remove 
@synthesize mainWindowController = _mainWindowController;


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.mainWindowController = [[MainWindowController alloc] init];
//    [self.mainWindowController loadWindow];
    
    ;
    [[CTConfiguration sharedInstance] setConfFilePath:[NSString stringWithFormat:@"%@/demoapp.conf", NSHomeDirectory()]];
    
    [[CTConfiguration sharedInstance] startDevelopmentVersion];
    
    [self.mainWindowController showWindow:self];
    
}

@end
