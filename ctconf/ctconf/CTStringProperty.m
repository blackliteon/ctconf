//
//  CTStringProperty.m
//  ctconf
//
//  Created by Dmitry Nikolaev on 08.07.12.
//  Copyright (c) 2012 cocotype.com. All rights reserved.
//

#import "CTStringProperty.h"

@implementation CTStringProperty

- (BOOL) isValueEqualTo: (id) newValue {
    NSString *normalizedCurrent = _value ? _value : self.defaultValue;
    NSString *normalizedNew = newValue ? newValue : self.defaultValue;
    
    if (normalizedCurrent == normalizedNew) return YES;
    if (normalizedCurrent == nil || normalizedNew == nil) return NO;
    return [normalizedCurrent isEqualToString:normalizedNew];
}

- (NSString *) toString {
    return self.value;
}

- (void) fromString: (NSString *) stringValue {
    self.value = stringValue;
}

@end
