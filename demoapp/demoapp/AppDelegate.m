//
//  AppDelegate.m
//  demoapp
//
//  Created by Дмитрий Николаев on 04.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import <ctconf/Test.h>

@implementation AppDelegate

@synthesize window = _window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    Test *test = [[Test alloc] init];
    [test testMe];
    // Insert code here to initialize your application
}

@end
