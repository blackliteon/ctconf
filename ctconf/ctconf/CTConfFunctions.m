//
//  CTConfFunctions.m
//  ctconf
//
//  Created by Dmitry Nikolaev on 14.01.13.
//  Copyright (c) 2013 cocotype.com. All rights reserved.
//

#import "CTConfFunctions.h"
#import "CTConfiguration.h"

void confInit(void) {
    
    NSString *confPath = nil;
    CTMode mode = CTNormalMode;
    BOOL useResourcesFromBundle = YES;
    
    NSArray *arguments = [[NSProcessInfo processInfo] arguments];
    for (int i = 0; i < arguments.count; i++) {
        NSString *currentArg = [arguments objectAtIndex:i];

        if ([currentArg isEqualToString:@"-ctconfmode"]) {
            mode = CTConfigurationMode;
            confPath = nil;
        }
        
        if ([currentArg isEqualToString:@"-ctconfpath"] && arguments.count > (i+1)) {
            confPath = [arguments objectAtIndex:i+1];
            useResourcesFromBundle = NO;
        }
        
    }
    
    if (mode == CTNormalMode && !confPath) {
        NSString *defaultConfPath = [[NSBundle mainBundle] pathForResource:@"app" ofType:@"conf"];
        confPath = defaultConfPath;
    }
    
    [CTConfiguration sharedInstance].confFilePath = confPath;
    [CTConfiguration sharedInstance].mode = mode;
    [CTConfiguration sharedInstance].useResourceFromBundle = useResourcesFromBundle;
    
    [[CTConfiguration sharedInstance] readConfig];
    
    if (mode == CTConfigurationMode) {
        [[CTConfiguration sharedInstance] showConfigurationPanel];
    }
    
}

CGFloat confDouble (NSString * propertyName, id object, NSString *objectKey, CGFloat defaultValue) {
    
    CTConfiguration *conf = [CTConfiguration sharedInstance];
    CGFloat result = [conf addDoubleProperty:propertyName toObject:object key:objectKey defaultValue:defaultValue];
    return result;
}

NSFont* confFont (NSString *propertyName, id object, NSString *objectKey, NSFont *defaultValue) {
    CTConfiguration *conf = [CTConfiguration sharedInstance];
    NSFont *result = [conf addFontProperty:propertyName toObject:object key:objectKey defaultValue:defaultValue];
    return result;
}

NSColor* confColor (NSString *propertyName, id object, NSString *objectKey, NSColor *defaultValue)  {
    CTConfiguration *conf = [CTConfiguration sharedInstance];
    NSColor *result = [conf addColorProperty:propertyName toObject:object key:objectKey defaultValue:defaultValue];
    return result;
}

NSEdgeInsets confEdgeInsets (NSString *propertyName, id object, NSString *objectKey, NSEdgeInsets defaultValue) {
    CTConfiguration *conf = [CTConfiguration sharedInstance];
    NSEdgeInsets result = [conf addEdgeInsetsProperty:propertyName toObject:object key:objectKey defaultValue:defaultValue];
    return result;
}

CTButtonStyle* confButtonStyle (NSString *propertyName, id object, NSString *objectKey, CTButtonStyle *defaultValue) {
    CTConfiguration *conf = [CTConfiguration sharedInstance];
    CTButtonStyle *result = [conf addButtonStyleProperty:propertyName toObject:object key:objectKey defaultValue:defaultValue];
    return result;
}


/* */

void confUnregister (id object) {
    CTConfiguration *conf = [CTConfiguration sharedInstance];
    [conf unregisterObjectFromUpdates:object];
}
