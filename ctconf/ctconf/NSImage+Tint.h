//
//  NSImage+Tint.h
//  ctconf
//
//  Created by Dmitry Nikolaev on 04.09.12.
//  Copyright (c) 2012 cocotype.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSImage (Tint)

- (NSImage *)tintedImageWithColor:(NSColor *)tint;
- (NSImage *)tintedImageWithColor:(NSColor *)tint backgroundColor:(NSColor *) bgColor opacity: (float) opacity;

@end
