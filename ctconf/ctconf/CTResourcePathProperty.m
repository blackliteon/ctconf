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
                        if ([objectKey.listener respondsToSelector:@selector(propertyWithName:updatedToValue:)]) {
                            [objectKey.listener propertyWithName:self.name updatedToValue:self.value];
                        }
                    }
                }
            }

            if (self.updateBlock) {
                self.updateBlock(self);
            }

        }
    } else {
        _value = value;
    }
}


@end
