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
    _value = value;
    
    if (self.objectOwnedProperty) {
        [self.objectOwnedProperty setValue:value forKey:self.objectKey];
    }
}

- (NSString *) toString {
    return [self.value stringValue];
}

- (void) fromString: (NSString *) stringValue {
    CGFloat floatVal = [stringValue floatValue];
    self.value = [NSNumber numberWithFloat:floatVal];
}


@end
