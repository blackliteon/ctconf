//
//  CTConfiguration.m
//  ctconf
//
//  Created by Dmitry Nikolaev on 05.07.12.
//  Copyright (c) 2012 cocotype.com. All rights reserved.
//

#import "CTConfiguration.h"
#import "CTProperty.h"
#import "CTPanelController.h"

#define CONF_FILE @"/Users/dima/ct.conf" // temprorary and for the start using concrete place

@interface CTConfiguration ()

@property (strong, nonatomic) NSMutableArray *properties;
@property (strong, nonatomic) CTPanelController *panelController;

@end

@implementation CTConfiguration

static id sharedInstance = nil;

@synthesize properties = _properties;
@synthesize panelController = _panelController;

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

- (void) saveTextToConfFile: (NSString *) text {
    NSURL *confFileUrl = [NSURL fileURLWithPath:CONF_FILE];
    NSError *error;
    
    if (![text writeToURL:confFileUrl atomically:NO encoding:NSUTF8StringEncoding error:&error]) {
        NSLog(@"Error while trying to create conf file: %@", [error localizedDescription]);
    }
}

- (NSString *) propertiesArrayToStringWithDefaultValues: (NSArray *) propArray {
    NSMutableString *fileText = [NSMutableString string];
    for (CTProperty *property in propArray) {
        property.value = property.defaultValue;
        NSString *textLine = [NSString stringWithFormat:@"%@ = %@", property.name, [property toString]];
        [fileText appendFormat:@"%@\n", textLine];
    }
    return fileText;
}

- (void) startNewConfFile {
    [self saveTextToConfFile:[self propertiesArrayToStringWithDefaultValues:self.properties]];
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

- (void) loadTextAsConf: (NSString *) text unusedProperties: (NSArray **) propertiesArray {
    
    // save all properties in dict
    
    NSMutableDictionary *checkDict = [[NSMutableDictionary alloc] init];
    for (CTProperty *property in self.properties) {
        [checkDict setObject:property forKey:property.name];
    }

    // enumerate lines
    
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
            
            if ([self haveProperty:propertyName]) {
                CTProperty *property = [self propertyByName:propertyName];
                [property fromString:propertyStrValue];
                [checkDict removeObjectForKey:propertyName];
            } else {
                NSLog(@"Warning: config text contains property that not found in app: %@", propertyName);
            }
        }
    }];
    
    // handle uset properties
    
    if (propertiesArray != NULL) {
        *propertiesArray = [checkDict allValues];
    }
    
    
}

- (void) loadConfFile {
    NSString *confText = [NSString stringWithContentsOfFile:CONF_FILE encoding:NSUTF8StringEncoding error:nil];
    [self loadTextAsConf:confText unusedProperties:nil];
}

- (void) start {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:CONF_FILE]) {
        [self startNewConfFile];
    }
    [self loadConfFile];
}

- (void) startWithConfigurer {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:CONF_FILE]) {
        [self startNewConfFile];
    }
    NSString *fileText = [NSString stringWithContentsOfFile:CONF_FILE encoding:NSUTF8StringEncoding error:nil];
    NSArray *unsetProperties;
    [self loadTextAsConf:fileText unusedProperties:&unsetProperties];
    
    // append unset properties
    
    NSString *confText;
    if ([unsetProperties count] > 0) {
        NSString *appendText = [self propertiesArrayToStringWithDefaultValues:unsetProperties];
        confText = [NSString stringWithFormat:@"%@\n%@", fileText, appendText];
    } else {
        confText = fileText;
    }
    
    // panel
    
    self.panelController = [[CTPanelController alloc] initWithWindowNibName:@"CTPanel"];
    [self.panelController loadWindow];
    CTPanel *panel = (CTPanel *)self.panelController.window;
    panel.ctDelegate = self;

    // initial values
    
    [self.panelController setText:confText];
    
    // let's show it
    
    [self.panelController showWindow:self];
    
}

- (void) startProduction {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"ct" ofType:@"conf"];
    if ([fileManager fileExistsAtPath:path]) {
        NSString *confText = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        [self loadTextAsConf:confText unusedProperties:nil];
    } else {
        NSLog(@"Error: Can't find ct.conf in main bundle: %@. Use default values.", path);
    }
}


- (void) save {
    NSString *text = self.panelController.text;

    [self loadTextAsConf:text unusedProperties:nil];
    [self saveTextToConfFile:text];
    
}


@end
