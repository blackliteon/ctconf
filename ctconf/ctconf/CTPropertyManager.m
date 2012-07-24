//
//  CTPropertyManager.m
//  ctconf
//
//  Created by Dmitry Nikolaev on 24.07.12.
//  Copyright (c) 2012 cocotype.com. All rights reserved.
//

#import "CTPropertyManager.h"
#import "CTProperty.h"

@interface CTPropertyManager ()

@property (strong, nonatomic) NSMutableDictionary *propertyDict;
@property (strong, nonatomic) NSMutableDictionary *stringDict;

@end

@implementation CTPropertyManager

@synthesize delegate = _delegate;
@synthesize configText = _configText;

@synthesize propertyDict = _propertyDict;
@synthesize stringDict = _stringDict;

- (void) _fillStringsValuesFromText: (NSString *) text {
    [self.stringDict removeAllObjects];
    
    [text enumerateLinesUsingBlock:^(NSString *line, BOOL *stop) {
        NSString *trimmedString = [line stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        if ([trimmedString hasPrefix:@"#"]) {
            return;
        }
        
        NSArray *components = [trimmedString componentsSeparatedByString:@"="];
        
        if ([components count] == 2) {
            NSString *leftStr = [components objectAtIndex:0];
            NSString *rightStr = [components lastObject];
            
            NSString *propertyName = [leftStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            NSString *propertyStrValue = [rightStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            
            [self.stringDict setObject:propertyStrValue forKey:propertyName];
        }
    }];
}

- (void) _refreshPropertyValue: (CTProperty *) property { // and appent to text for dev mode
    
    NSString *strValInConfig = [self.stringDict objectForKey:property.name];
    if (strValInConfig) {
        [property fromString:strValInConfig];
    } else { 
        property.value = property.defaultValue;
        [self.delegate propertyValueNotFound:property];
    }
}

- (void) setConfigText: (NSString *) configText {
    if (![_configText isEqualToString:configText]) {
        _configText = [configText copy];
        
        [self _fillStringsValuesFromText:configText];
        [self.propertyDict enumerateKeysAndObjectsUsingBlock:^(NSString* name, CTProperty *property, BOOL *stop) {
            [self _refreshPropertyValue:property];
        }];
    }
}

- (void) addProperty: (CTProperty *) property {
    
    CTProperty *registeredProperty = [self.propertyDict objectForKey:property.name];
    
    if (!registeredProperty) {
        [self.propertyDict setObject:property forKey:property.name];
        [self _refreshPropertyValue:property];
    } else {
        if (registeredProperty.class != property.class) {
            [NSException raise:@"One name for different properties types" format:@"Property %@ has multiple types simultaneously", property.name];
        }
        
        [registeredProperty addAllObjectSetterInfoFromProperty:property];
    }
}

- (CTProperty *) propertyByName: (NSString *) name {
    return [self.propertyDict objectForKey:name];
}

- (void) unregisterObjectFromUpdates: (id) object {
    [self.propertyDict enumerateKeysAndObjectsUsingBlock:^(NSString* name, CTProperty *property, BOOL *stop) {
        [property removeObjectFromUpdatesTracking:object];
    }];
}

#pragma mark - Initializers

- (NSMutableDictionary *) propertyDict {
    if (!_propertyDict) {
        _propertyDict = [[NSMutableDictionary alloc] init];
    }
    return _propertyDict;
}

- (NSMutableDictionary *) stringDict {
    if (!_stringDict) {
        _stringDict = [[NSMutableDictionary alloc] init];
    }
    return _stringDict;
}

@end
