//
//  CTPanelController.h
//  ctconf
//
//  Created by Dmitry Nikolaev on 06.07.12.
//  Copyright (c) 2012 cocotype.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CTPanel.h"

@interface CTPanelController : NSWindowController

- (void) setText: (NSString *) text;
- (NSString *) text;

@end
