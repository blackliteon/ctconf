//
//  NSImage+Tint.m
//  ctconf
//
//  Created by Dmitry Nikolaev on 04.09.12.
//  Copyright (c) 2012 cocotype.com. All rights reserved.
//

#import "NSImage+Tint.h"

@implementation NSImage (Tint)

- (NSImage *)tintedImageWithColor:(NSColor *)tint
{
    NSSize size = [self size];
    NSRect imageBounds = NSMakeRect(0, 0, size.width, size.height);
    
    NSImage *copiedImage = [self copy];
    
    [copiedImage lockFocus];
    
    [tint set];
    NSRectFillUsingOperation(imageBounds, NSCompositeSourceAtop);
    
    [copiedImage unlockFocus];
    
    return copiedImage;
}

- (NSImage *)tintedImageWithColor:(NSColor *)tint backgroundColor:(NSColor *) bgColor opacity: (float) opacity {
    NSImage *tintImage = [self tintedImageWithColor:tint];
    float appliedOpacity = 1 - opacity;
    NSColor *color = [bgColor colorWithAlphaComponent:appliedOpacity];
    NSImage *tintedWithOpacity = [tintImage tintedImageWithColor:color];
    return tintedWithOpacity;
}

@end
