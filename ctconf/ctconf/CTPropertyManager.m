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
@property (strong, nonatomic) NSMutableDictionary *linkDict;

@end

@implementation CTPropertyManager

@synthesize delegate = _delegate;
@synthesize configText = _configText;

@synthesize propertyDict = _propertyDict;
@synthesize stringDict = _stringDict;
@synthesize linkDict = _linkDict;

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
    
    // if property set, just use it value
    
    if (strValInConfig) {
        [property fromString:strValInConfig];
    } else { 
        
        // if it's not ...
        
        if (property.masterPropertyName) {
            
            // ... try to use value from master property
            
            CTProperty *masterProperty = [self.propertyDict objectForKey:property.masterPropertyName];
            
            if (masterProperty) {
                property.value = masterProperty.value;
            } else { // we have reference to master, but there is no master property yet registered (seems it will be registered later), so, just use default value.
                property.value = nil;
            }
            
        } else {
            
            // ... or just use default
            
            property.value = nil;
        }
        
        if (!property.optional) {
            [self.delegate propertyValueNotFound:property];
        }
    }

    // update another properties that linked to this one (this is master property)
    
    NSMutableArray *linkedProperties = [self.linkDict objectForKey:property.name];
    if (linkedProperties) {
        for (CTProperty *linkedProperty in linkedProperties) {
            NSString *linkedPropertyStrValue = [self.stringDict objectForKey:linkedProperty.name];
            if (!linkedPropertyStrValue) {
                NSLog(@"Found linked property without value: %@", linkedProperty.name);
                linkedProperty.value = property.value;
            }
        }
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
        
        NSLog(@"unregistered property %@. Registration.", property.name);
        
        [self.propertyDict setObject:property forKey:property.name];

        // add link to link dict
        
        if (property.masterPropertyName) {
            NSMutableArray *allLinkedProperties = [self.linkDict objectForKey:property.masterPropertyName];
            if (!allLinkedProperties) {
                allLinkedProperties = [[NSMutableArray alloc] init];
                [self.linkDict setObject:allLinkedProperties forKey:property.masterPropertyName];
            }
            [allLinkedProperties addObject:property];
        }
        
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

- (NSMutableDictionary *) linkDict {
    if (!_linkDict) {
        _linkDict = [[NSMutableDictionary alloc] init];
    }
    return _linkDict;
}

@end
