//
//  AppDelegate.m
//  TestFramework
//
//  Created by Dmitry Nikolaev on 28.09.12.
//  Copyright (c) 2012 Dmitry Nikolaev. All rights reserved.
//

#import "AppDelegate.h"
#import <ctconf/ctconf.h>

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    NSString *defaultConfPath = [[NSBundle mainBundle] pathForResource:@"labelbutton" ofType:@"conf"];
    [CTConfiguration sharedInstance].confFilePath = defaultConfPath;
    [CTConfiguration sharedInstance].mode = CTConfigurationMode;
    
    [[CTConfiguration sharedInstance] readConfig];
    [[CTConfiguration sharedInstance] showConfigurationPanel];
}

@end
