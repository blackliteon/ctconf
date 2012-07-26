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
    
    NSNumber *normalizedCurrent = _value ? _value : self.defaultValue;
    NSNumber *normalizedNew = newValue ? newValue : self.defaultValue;
    
    if (normalizedCurrent == normalizedNew) return YES;
    if (normalizedCurrent == nil || normalizedNew == nil) return NO;
    return [normalizedCurrent isEqualToNumber:normalizedNew];
}

- (NSString *) toString {
    return [self.value stringValue];
}

@end
