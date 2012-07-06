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
#import "CTDoubleProperty.h"
#import "CTBooleanProperty.h"
#import "CTEnumerateProperty.h"

#define CONF_FILE @"/Users/dima/ct.conf" // temprorary and for the start using concrete place

@interface CTConfiguration ()

@property (strong, nonatomic) NSMutableArray *properties;
@property (strong, nonatomic) CTPanelController *panelController;

@end

@implementation CTConfiguration

static id sharedInstance = nil;

@synthesize properties = _properties;
@synthesize panelController = _panelController;

#pragma mark - Private

- (void) saveTextToDevelopmentConfFile: (NSString *) text {
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

- (void) createDevelopmentConfFileWithDefaultValues {
    [self saveTextToDevelopmentConfFile:[self propertiesArrayToStringWithDefaultValues:self.properties]];
}

- (BOOL) hasProperty: (NSString *) propertyName {
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

- (void) loadPropertiesValuesFromText: (NSString *) text unusedProperties: (NSArray **) propertiesArray {
    
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
            
            if ([self hasProperty:propertyName]) {
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

- (void) loadPropertiesValuesFromDevelopmentConf {
    NSString *confText = [NSString stringWithContentsOfFile:CONF_FILE encoding:NSUTF8StringEncoding error:nil];
    [self loadPropertiesValuesFromText:confText unusedProperties:nil];
}

- (void) save {
    NSString *text = self.panelController.text;
    
    [self loadPropertiesValuesFromText:text unusedProperties:nil];
    [self saveTextToDevelopmentConfFile:text];
    
}

#pragma mark - Public

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

- (void) start {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:CONF_FILE]) {
        [self createDevelopmentConfFileWithDefaultValues];
    }
    [self loadPropertiesValuesFromDevelopmentConf];
}

- (void) startDevelopmentVersion {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:CONF_FILE]) {
        [self createDevelopmentConfFileWithDefaultValues];
    }
    NSString *fileText = [NSString stringWithContentsOfFile:CONF_FILE encoding:NSUTF8StringEncoding error:nil];
    NSArray *unsetProperties;
    [self loadPropertiesValuesFromText:fileText unusedProperties:&unsetProperties];
    
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

- (void) startProductionVersion {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"ct" ofType:@"conf"];
    if ([fileManager fileExistsAtPath:path]) {
        NSString *confText = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        [self loadPropertiesValuesFromText:confText unusedProperties:nil];
    } else {
        NSLog(@"Error: Can't find ct.conf in main bundle: %@. Use default values.", path);
    }
}

#pragma mark Properties

- (CGFloat) declareDoubleInObject: (id) object withName: (NSString *) name defaultValue:(CGFloat) defaultVal {

    CTDoubleProperty *property = [[CTDoubleProperty alloc] init];
    property.name = name;
    property.defaultValue = [NSNumber numberWithFloat:defaultVal];
    property.objectOwnedProperty = object;
    
    [self.properties addObject:property];
    
    return defaultVal;
}

- (BOOL) declareBooleanInObject: (id) object withName: (NSString *) name defaultValue:(BOOL) defaultVal {
    CTBooleanProperty *property = [[CTBooleanProperty alloc] init];
    property.name = name;
    property.defaultValue = [NSNumber numberWithFloat:defaultVal];
    property.objectOwnedProperty = object;
    
    [self.properties addObject:property];
    
    return defaultVal;
}

- (NSString *) declareEnumerateInObject: (id) object withName: (NSString *) name defaultValue:(NSString *) defaultVal possibleValues: (NSString *) possibleValue1, ...{
    CTEnumerateProperty *property = [[CTEnumerateProperty alloc] init];
    property.name = name;
    property.defaultValue = defaultVal;
    property.objectOwnedProperty = object;
    
    NSMutableArray *possibleValues = [[NSMutableArray alloc] init];
    va_list args;
    va_start(args, possibleValue1);
    for (NSString *arg = possibleValue1; arg != nil; arg = va_arg(args, NSString*))
    {
        [possibleValues addObject:arg];
    }
    va_end(args);
    property.possibleValues = possibleValues;
    
    [self.properties addObject:property];
    
    return defaultVal;
}




@end
