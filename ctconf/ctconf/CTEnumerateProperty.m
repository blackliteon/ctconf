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
    
    if (_value == nil && newValue == nil) return YES;
    if (_value != newValue && (_value == nil || newValue == nil)) return NO;
    
    NSString *oldStr = _value;
    NSString *newStr = newValue;
    
    return [oldStr isEqualToString:newStr];
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
