//
//  CTProperty.m
//  ctconf
//
//  Created by Dmitry Nikolaev on 05.07.12.
//  Copyright (c) 2012 cocotype.com. All rights reserved.
//

#import "CTProperty.h"

@implementation CTProperty

@synthesize name = _name;
@synthesize propertyType = _propertyType;
@synthesize value = _value;
@synthesize defaultValue = _defaultValue;

@synthesize objectOwnedProperty = _objectOwnedProperty;
@synthesize objectKey = _objectKey;

- (void) setValue:(id)value {
    
    if (![self isValueEqualTo:value]) {
        _value = value;
        
        if (self.objectOwnedProperty) {
            [self.objectOwnedProperty setValue:value forKey:self.objectKey];
        }
    }
}

- (BOOL) isValueEqualTo: (id) newValue {
    NSLog(@"Error: subclasses should override isValueEqualTo:");
    [self doesNotRecognizeSelector:_cmd];
    return NO;
}


- (NSString *) toString {
    NSLog(@"Error: subclasses should override toString");
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (void) fromString: (NSString *) stringValue {
    NSLog(@"Error: subclasses should override fromString:");
    [self doesNotRecognizeSelector:_cmd];
}


@end
