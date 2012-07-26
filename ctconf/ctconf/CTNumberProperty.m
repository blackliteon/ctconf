//
//  CTNumberProperty.m
//  ctconf
//
//  Created by Dmitry Nikolaev on 06.07.12.
//  Copyright (c) 2012 cocotype.com. All rights reserved.
//

#import "CTNumberProperty.h"

@implementation CTNumberProperty

- (BOOL) isValueEqualTo: (id) newValue {
    
    if (_value == nil && newValue == nil) return YES;
    if (_value != newValue && (_value == nil || newValue == nil)) return NO;
    
    NSNumber *currentNumber = _value;
    NSNumber *newNumber = newValue;
    
    return [currentNumber isEqualToNumber:newNumber];
}

- (NSString *) toString {
    return [self.value stringValue];
}

@end
