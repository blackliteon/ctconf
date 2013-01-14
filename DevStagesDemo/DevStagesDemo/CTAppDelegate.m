//
//  CTAppDelegate.m
//  DevStagesDemo
//
//  Created by Dmitry Nikolaev on 14.01.13.
//  Copyright (c) 2013 Cocotype. All rights reserved.
//

#import "CTAppDelegate.h"
#import <ctconf/ctconf.h>

@implementation CTAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    confInit();
    
    CGFloat x = confDouble(@"buttonX", self, @"buttonX", 250);
    [self.button setFrameOrigin:NSMakePoint(x, 100)];
}

- (void) setButtonX: (CGFloat) buttonX {
    [self.button setFrameOrigin:NSMakePoint(buttonX, 100)];
}

@end
