//
//  CTUnicharProperty.m
//  ctconf
//
//  Created by Dmitry Nikolaev on 25.07.12.
//  Copyright (c) 2012 cocotype.com. All rights reserved.
//

#import "CTUnicharProperty.h"

@implementation CTUnicharProperty

- (NSString *) toString {
    NSString * hexString = [NSString stringWithFormat:@"0x%x", self.value];
    return hexString;
}

- (void) fromString: (NSString *) stringValue {
    if (stringValue.length > 2) {
        unsigned int iValue;
        NSScanner* pScanner = [NSScanner scannerWithString: stringValue];
        [pScanner scanHexInt: &iValue];
        self.value = [NSNumber numberWithUnsignedShort:iValue];
    } else {
        //self.value = nil;
    }
}

@end
