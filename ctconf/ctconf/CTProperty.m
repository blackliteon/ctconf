//
//  CTProperty.m
//  ctconf
//
//  Created by Dmitry Nikolaev on 05.07.12.
//  Copyright (c) 2012 cocotype.com. All rights reserved.
//

#import "CTProperty.h"
#import "CTObjectKey.h"

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
}

- (void) setValue:(id)value {
    
    if (![self isValueEqualTo:value]) {
        _value = value;
        
        for (CTObjectKey *objectKey in self.objectsThatTracksProperty) {
            if (objectKey) {
                [objectKey.object setValue:value forKey:objectKey.key];
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
    
    CTObjectKey *objectKey = [[CTObjectKey alloc] init];
    objectKey.object = object;
    NSArray *propertyNameComponents = [self.name componentsSeparatedByString:@"."];
    objectKey.key = [propertyNameComponents lastObject];
    
    [self.objectsThatTracksProperty addObject:objectKey];
}

- (void) addObjectThatTracksUpdates: (id) object key: (NSString *) key {
    CTObjectKey *objectKey = [[CTObjectKey alloc] init];
    objectKey.object = object;
    objectKey.key = key;
    
    [self.objectsThatTracksProperty addObject:objectKey];
}


- (void) removeObjectFromUpdatesTracking: (id) object {
    
    for (int i = (int)self.objectsThatTracksProperty.count - 1; i >= 0; i--) {
        CTObjectKey *currentObjectKey = [self.objectsThatTracksProperty objectAtIndex:i];
        if (currentObjectKey.object == object) {
            [self.objectsThatTracksProperty removeObjectAtIndex:i];
        }
    }
}

- (CTObjectKey *) firstObjectThatTracksUpdates { 
    if (self.objectsThatTracksProperty.count > 0) {
        return [self.objectsThatTracksProperty objectAtIndex:0];
    }
    return nil;
}

@end
