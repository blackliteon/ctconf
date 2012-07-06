//
//  CTBooleanProperty.m
//  ctconf
//
//  Created by Dmitry Nikolaev on 06.07.12.
//  Copyright (c) 2012 cocotype.com. All rights reserved.
//

#import "CTBooleanProperty.h"

@implementation CTBooleanProperty

- (NSString *) toString {
    return [self.value boolValue] ? @"yes" : @"no";
}

- (void) fromString: (NSString *) stringValue {
    NSString *normalizedStr = [stringValue lowercaseString];
    if ([normalizedStr isEqualToString:@"yes"]) {
        self.value = [NSNumber numberWithBool:YES];
        return;
    }
    
    if ([normalizedStr isEqualToString:@"no"]) {
        self.value = [NSNumber numberWithBool:NO];
        return;
    }

    NSLog(@"Boolean value for property %@ = %@ is invalid (yes or no required). Default used.", self.name, stringValue);
}

@end
