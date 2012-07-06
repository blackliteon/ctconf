//
//  CTConfiguration.m
//  ctconf
//
//  Created by Dmitry Nikolaev on 05.07.12.
//  Copyright (c) 2012 cocotype.com. All rights reserved.
//

#import "CTConfiguration.h"
#import "CTProperty.h"

@interface CTConfiguration ()

@property (strong, nonatomic) NSMutableArray *properties;

@end

@implementation CTConfiguration

static id sharedInstance = nil;

@synthesize properties = _properties;

+ (CTConfiguration *) sharedInstance {
    if (!sharedInstance) {
        sharedInstance = [[CTConfiguration alloc] init];
    } 
    return sharedInstance;
}

- (id)init {
    self = [super init];
    if (self) {
        _properties = [NSMutableArray array];
    }
    return self;
}

- (CGFloat) declareCGFloatPropertyInObject: (id) object withName: (NSString *) name defaultValue:(CGFloat) defaultVal {
    CTProperty *property = [[CTProperty alloc] init];
    property.name = name;
    property.propertyType = CTPropertyTypeCGFloat;
    property.defaultValue = [NSNumber numberWithFloat:defaultVal];
    
    property.objectOwnedProperty = object;
    
    NSArray *propertyNameComponents = [name componentsSeparatedByString:@"."];
    property.objectKey = [propertyNameComponents lastObject];
    
    [self.properties addObject:property];
    
    return defaultVal;
}

#define CONF_FILE @"/Users/dima/ctconf.conf" // temprorary and for the start using concrete place

- (void) startNewConfFile {
    NSMutableString *fileText = [NSMutableString string];
    for (CTProperty *property in self.properties) {
        property.value = property.defaultValue;
        NSString *textLine = [NSString stringWithFormat:@"%@ = %@", property.name, [property toString]];
        [fileText appendFormat:@"%@\n", textLine];
    }
    
    NSURL *confFileUrl = [NSURL fileURLWithPath:CONF_FILE];
    NSError *error;
    
    if (![fileText writeToURL:confFileUrl atomically:NO encoding:NSUTF8StringEncoding error:&error]) {
        NSLog(@"Error while trying to create conf file: %@", [error localizedDescription]);
    }
}

- (BOOL) haveProperty: (NSString *) propertyName {
    for (CTProperty *property in self.properties) {
        if ([property.name isEqualToString:propertyName]) {
            return YES;
        }
    }
    return NO;
}

- (CTProperty *) propertyByName: (NSString *) propertyName {
    for (CTProperty *property in self.properties) {
        if ([property.name isEqualToString:propertyName]) {
            return property;
        }
    }
    return nil;
}

- (void) loadConfFile {
    NSString *confText = [NSString stringWithContentsOfFile:CONF_FILE encoding:NSUTF8StringEncoding error:nil];
    [confText enumerateLinesUsingBlock:^(NSString *line, BOOL *stop) {
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
            
            if ([self haveProperty:propertyName]) {
                CTProperty *property = [self propertyByName:propertyName];
                [property fromString:propertyStrValue];
            } else {
                NSLog(@"Warning: config file %@ contains property that not found in app: %@", CONF_FILE, propertyName);
            }
        }
        
        
    }];
}

- (void) start {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:CONF_FILE]) {
        [self startNewConfFile];
    }
    [self loadConfFile];
}


@end
