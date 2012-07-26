//
//  CTResourcePath.m
//  ctconf
//
//  Created by Dmitry Nikolaev on 15.07.12.
//  Copyright (c) 2012 cocotype.com. All rights reserved.
//

#import "CTResourcePathProperty.h"
#import "CTObjectSetterInfo.h"

@implementation CTResourcePathProperty

@synthesize delegate = _delegate;

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
    self.value = stringValue;
}

- (void) setValue:(id)value {
    
    if (![self isValueEqualTo:value]) {
        _value = value;
        
        if (!self.disableUpdateNotification) {
            for (CTObjectSetterInfo *objectKey in self.allObjectSetterInfo) {
                if (objectKey) {
                    NSString *path = [self.delegate absolutePathForResourceWithConfigPath:self.value];
                    
                    if (objectKey.object) {
                        [objectKey.object setValue:path forKey:objectKey.key];
                    }
                    
                    if (objectKey.listener) {
                        [objectKey.listener propertyWithName:self.name updatedToValue:path];
                    }
                    
                }
            }
        }
    }
}


@end
