//
//  CTStringColorProperty.m
//  ctconf
//
//  Created by Dmitry Nikolaev on 13.07.12.
//  Copyright (c) 2012 cocotype.com. All rights reserved.
//

#import "CTColorProperty.h"
#import "NSColor+FromHex.h"

@implementation CTColorProperty

- (BOOL) isValueEqualTo: (id) newValue {
    NSColor *currentColor = self.value;
    NSColor *newColor = newValue;
    
    NSString *currentColorHex = [currentColor hexString];
    NSString *newColorHex = [newColor hexString];
    
    return [currentColorHex isEqualToString:newColorHex];
}

- (NSString *) toString {
    NSColor *currentColor = self.value;
    NSString *currentColorHex = [currentColor hexString];

    return [NSString stringWithFormat:@"#%@", currentColorHex];
}

- (void) fromString: (NSString *) stringValue {
    if ([stringValue hasPrefix:@"#"]) {
        NSString *clearHexValue = [stringValue substringFromIndex:1];
        self.value = [NSColor colorFromHexRGB:clearHexValue];
    } else {
        NSLog(@"Property %@ has invalid value for color: '%@'. Should be in format '#xxxxxx'", self.name, stringValue);
    }
}
@end
