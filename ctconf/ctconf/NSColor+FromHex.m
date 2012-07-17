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
	unsigned char redByte, greenByte, blueByte;
	
	if (nil != inColorString)
	{
		NSScanner *scanner = [NSScanner scannerWithString:inColorString];
		(void) [scanner scanHexInt:&colorCode];	// ignore error
	}
	redByte		= (unsigned char) (colorCode >> 16);
	greenByte	= (unsigned char) (colorCode >> 8);
	blueByte	= (unsigned char) (colorCode);	// masks off high bits
	result = [NSColor
              colorWithCalibratedRed:		(float)redByte	/ 0xff
              green:	(float)greenByte/ 0xff
              blue:	(float)blueByte	/ 0xff
              alpha:1.0];
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
    
    NSString *result = [NSString stringWithFormat:@"%02x%02x%02x", rDec, gDec, bDec];
    return result;
}


@end
