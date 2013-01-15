//
//  NSColor+CTAdditions.m
//  ctconf
//
//  Created by Dmitry Nikolaev on 15.01.13.
//  Copyright (c) 2013 cocotype.com. All rights reserved.
//

#import "NSColor+CTAdditions.h"
#import "NSColor+FromHex.h"

@implementation NSColor (CTAdditions)

- (NSString *) confStringValue {
    NSString *currentColorHex = [self hexString];
    return [NSString stringWithFormat:@"#%@", currentColorHex];
}

+ (NSColor *) fromConfStringValue: (NSString *) strValue {
    if ([strValue hasPrefix:@"#"]) {
        NSString *clearHexValue = [strValue substringFromIndex:1];
        NSColor *color = [NSColor colorFromHexRGB:clearHexValue];
        return color;
    } else {
        return nil;
    }
}

@end
