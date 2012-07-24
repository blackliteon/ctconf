//
//  CTProperty.m
//  ctconf
//
//  Created by Dmitry Nikolaev on 05.07.12.
//  Copyright (c) 2012 cocotype.com. All rights reserved.
//

#import "CTProperty.h"
#import "CTObjectSetterInfo.h"

@interface CTProperty ()

@property (strong, nonatomic) NSMutableArray *objectSetterInfoArray;

@end

@implementation CTProperty

@synthesize name = _name;
@synthesize propertyType = _propertyType;
@synthesize value = _value;
@synthesize defaultValue = _defaultValue;

@synthesize objectKey = _objectKey;

@synthesize objectSetterInfoArray = _objectSetterInfoArray;

- (id)init {
    self = [super init];
    if (self) {
        _objectSetterInfoArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void) setName:(NSString *)name {
    _name = [name copy];
}

- (void) setValue:(id)value {
    
    if (![self isValueEqualTo:value]) {
        _value = value;
        
        for (CTObjectSetterInfo *objectKey in self.objectSetterInfoArray) {
            if (objectKey) {
                
                if (objectKey.object) {
                    [objectKey.object setValue:value forKey:objectKey.key];
                }
                
                if (objectKey.listener) {
                    [objectKey.listener propertyWithName:self.name updatedToValue:value];
                }
                
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

- (void) addObjectThatTracksUpdates: (id) object key: (NSString *) key {
    CTObjectSetterInfo *objectKey = [[CTObjectSetterInfo alloc] init];
    objectKey.object = object;
    objectKey.key = key;
    
    [self.objectSetterInfoArray addObject:objectKey];
}

- (void) addPropertyListener: (id<CTPropertyListener>) propertyListener {
    CTObjectSetterInfo *objectListenerInfo = [[CTObjectSetterInfo alloc] init];
    objectListenerInfo.listener = propertyListener;
    [self.objectSetterInfoArray addObject:objectListenerInfo];
}


- (void) addAllObjectSetterInfoFromProperty: (CTProperty *) property {
    for (CTObjectSetterInfo *objectKey in property.allObjectSetterInfo) {
        [self.objectSetterInfoArray addObject:objectKey];
    }
}

- (NSArray *) allObjectSetterInfo {
    return self.objectSetterInfoArray;
}

- (void) removeObjectFromUpdatesTracking: (id) object {
    
    for (int i = (int)self.objectSetterInfoArray.count - 1; i >= 0; i--) {
        CTObjectSetterInfo *currentObjectKey = [self.objectSetterInfoArray objectAtIndex:i];
        if (currentObjectKey.object == object) {
            [self.objectSetterInfoArray removeObjectAtIndex:i];
        }
    }
}

@end
