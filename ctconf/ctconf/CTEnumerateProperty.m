//
//  CTEnumerateProperty.m
//  ctconf
//
//  Created by Dmitry Nikolaev on 06.07.12.
//  Copyright (c) 2012 cocotype.com. All rights reserved.
//

#import "CTEnumerateProperty.h"

@implementation CTEnumerateProperty

@synthesize possibleValues = _possibleValues;

- (BOOL) isValueEqualTo: (id) newValue {
    
    id normalizedCurrent = _value ? _value : self.defaultValue;
    id normalizedNew = newValue ? newValue : self.defaultValue;
    
    if (normalizedCurrent == normalizedNew) return YES;
    if (normalizedCurrent == nil || normalizedNew == nil) return NO;
    return [normalizedCurrent isEqualToString:normalizedNew];
}

- (NSString *) toString {
    return self.value;
}

- (void) fromString: (NSString *) stringValue {
    if ([self.possibleValues containsObject:stringValue]) {
        self.value = stringValue;
    } else {
        NSLog(@"Value %@ in property %@ not defined as possible value. Default used.", stringValue, self.name);
    }
}

@end
