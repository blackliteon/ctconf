//
//  CTButtonStyleProperty.m
//  ctconf
//
//  Created by Dmitry Nikolaev on 15.01.13.
//  Copyright (c) 2013 cocotype.com. All rights reserved.
//

#import "CTButtonStyleProperty.h"
#import "CTButtonStyle.h"
#import "CTConfiguration.h"

@implementation CTButtonStyleProperty

- (BOOL) isValueEqualTo: (id) newValue {
    NSString *normalizedCurrent = _value ? _value : self.defaultValue;
    NSString *normalizedNew = newValue ? newValue : self.defaultValue;
    
    if (normalizedCurrent == normalizedNew) return YES;
    if (normalizedCurrent == nil || normalizedNew == nil) return NO;
    return [normalizedCurrent isEqual:normalizedNew];
}

- (NSString *) toString {
    CTButtonStyle *style = self.value;
    return [style stringValue];
}

- (void) fromString: (NSString *) stringValue {
    self.value = [CTButtonStyle buttonStyleFromString:stringValue];
}

- (id) transformedValue {
    
    CTConfiguration *conf = [CTConfiguration sharedInstance];
    
    CTButtonStyle *style = [self.value copy];
    style.path = [conf normalizePath:style.path];
    
//    NSLog(@"transformed path: %@", style.path);
    
    return style;
}

@end
