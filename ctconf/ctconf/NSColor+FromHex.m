//
//  NSColor+FromHex.m
//  6 notes
//
//  Created by Dmitry Nikolaev on 23.08.11.
//  Copyright 2011 Apprium. All rights reserved.
//

#import "NSColor+FromHex.h"


@implementation NSColor (FromHex)

+ (NSColor *) colorFromHexRGB:(NSString *) inColorString
{
	NSColor *result = nil;
	unsigned int colorCode = 0;
	unsigned char redByte, greenByte, blueByte, alphaByte;
	
	if (nil != inColorString)
	{
		NSScanner *scanner = [NSScanner scannerWithString:inColorString];
		(void) [scanner scanHexInt:&colorCode];	// ignore error
	}
    
    if (inColorString.length <= 6) { // value without alpha
        redByte		= (unsigned char) (colorCode >> 16);
        greenByte	= (unsigned char) (colorCode >> 8);
        blueByte	= (unsigned char) (colorCode);	// masks off high bits
        alphaByte   = 0xff;
    } else {
        redByte		= (unsigned char) (colorCode >> 24);
        greenByte	= (unsigned char) (colorCode >> 16);
        blueByte	= (unsigned char) (colorCode >> 8);	// masks off high bits
        alphaByte   = (unsigned char) (colorCode);;
    }
    
	result = [NSColor
              colorWithCalibratedRed:		(float)redByte	/ 0xff
              green:	(float)greenByte/ 0xff
              blue:	(float)blueByte	/ 0xff
              alpha:(float)alphaByte	/ 0xff];
	return result;
}

- (NSString *) hexString {
    CGFloat r,g,b,alpha;
    
    NSColor *useColor = self;
    if (![[useColor colorSpaceName] isEqualToString:NSCalibratedRGBColorSpace]) {
        useColor = [self colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
    }
    
    [useColor getRed:&r green:&g blue:&b alpha:&alpha];
    NSUInteger rDec = (NSUInteger)(r * 0xff);
    NSUInteger gDec = (NSUInteger)(g * 0xff);
    NSUInteger bDec = (NSUInteger)(b * 0xff);
    NSUInteger aDec = (NSUInteger)(alpha * 0xff);
    
    NSString *result = nil;
    if (alpha == 1) {
        result = [NSString stringWithFormat:@"%02x%02x%02x", (unsigned int)rDec, (unsigned int)gDec, (unsigned int)bDec];
    } else {
        result = [NSString stringWithFormat:@"%02x%02x%02x%02x", (unsigned int)rDec, (unsigned int)gDec, (unsigned int)bDec, (unsigned int)aDec];

    }
    return result;
}


@end
