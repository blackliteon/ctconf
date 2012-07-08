//
//  NSColor+FromHex.h
//  demoapp
//
//  Created by Dmitry Nikolaev on 08.07.12.
//  Copyright (c) 2012 cocotype.com. All rights reserved.
//

#import <AppKit/AppKit.h>

@interface NSColor (FromHex)

+ (NSColor *) colorFromHexRGB:(NSString *) inColorString;

@end
