//
//  NSColor+FromHex.h
//  6 notes
//
//  Created by Dmitry Nikolaev on 23.08.11.
//  Copyright 2011 Apprium. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSColor (FromHex) 

+ (NSColor *) colorFromHexRGB:(NSString *) inColorString;

- (NSString *) hexString;

@end
