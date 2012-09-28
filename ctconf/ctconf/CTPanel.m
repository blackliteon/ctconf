//
//  CTPanel.m
//  ctconf
//
//  Created by Dmitry Nikolaev on 06.07.12.
//  Copyright (c) 2012 cocotype.com. All rights reserved.
//

#import "CTPanel.h"

@interface CTPanel ()


@end

@implementation CTPanel

@synthesize ctDelegate = _ctDelegate;

- (void) sendEvent:(NSEvent *)event {
    if ([event type] == NSKeyDown) {
        if (([event modifierFlags] & NSDeviceIndependentModifierFlagsMask) == NSCommandKeyMask) {
            
            if (event.keyCode == 1) {
                [self.ctDelegate save];
                return;
            }
            
            /* don't working on character layout other that english
            if ([[event charactersIgnoringModifiers] isEqualToString:@"s"]) {
                [self.ctDelegate save];
                return;
            }
             */
        }
    }
    [super sendEvent:event];
}

@end
