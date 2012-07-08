//
//  CTProperty.m
//  ctconf
//
//  Created by Dmitry Nikolaev on 05.07.12.
//  Copyright (c) 2012 cocotype.com. All rights reserved.
//

#import "CTProperty.h"

@interface CTProperty ()

@property (strong, nonatomic) NSMutableArray *objectsThatTracksProperty;

@end

@implementation CTProperty

@synthesize name = _name;
@synthesize propertyType = _propertyType;
@synthesize value = _value;
@synthesize defaultValue = _defaultValue;

@synthesize objectKey = _objectKey;

@synthesize objectsThatTracksProperty = _objectsThatTracksProperty;

- (id)init {
    self = [super init];
    if (self) {
        _objectsThatTracksProperty = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void) setName:(NSString *)name {
    _name = [name copy];
    NSArray *propertyNameComponents = [self.name componentsSeparatedByString:@"."];
    self.objectKey = [propertyNameComponents lastObject];
}

- (void) setValue:(id)value {
    
    if (![self isValueEqualTo:value]) {
        _value = value;
        
        for (id object in self.objectsThatTracksProperty) {
            if (object) {
                [object setValue:value forKey:self.objectKey];
            }
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

- (void) addObjectThatTracksUpdates: (id) object {
    [self.objectsThatTracksProperty addObject:object];
}

- (void) removeObjectFromUpdatesTracking: (id) object {
    
    for (int i = (int)self.objectsThatTracksProperty.count - 1; i >= 0; i--) {
        id currentObj = [self.objectsThatTracksProperty objectAtIndex:i];
        if (currentObj == object) {
            [self.objectsThatTracksProperty removeObjectAtIndex:i];
        }
    }
}


@end
