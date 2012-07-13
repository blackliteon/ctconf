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
#import "CTStringProperty.h"
#import "CTIntegerProperty.h"
#import "CTDoubleArrayProperty.h"
#import "CTSizeProperty.h"

#define CT_DEFAULT_SCENE_NAME_KEY @"CT_default_scene_name"

@interface CTConfiguration () <CTPanelControllerDelegate>

@property (strong, nonatomic) NSMutableArray *properties;
@property (strong, nonatomic) CTPanelController *panelController;

@property (strong, nonatomic) NSMutableDictionary *propertiesDict;
@property (strong, nonatomic) NSMutableDictionary *stringsDict;

@property (strong, nonatomic) id<CTScene> currentScene;
@property (assign, nonatomic) CTMode mode;

@end

@implementation CTConfiguration

static id sharedInstance = nil;

@synthesize confFilePath = _confFilePath;

@synthesize properties = _properties;
@synthesize panelController = _panelController;
@synthesize sceneManager = _sceneManager;

@synthesize propertiesDict = _propertiesDict;
@synthesize stringsDict = _stringsDict;

@synthesize currentScene = _currentScene;
@synthesize mode = _mode;

#pragma mark - Private

- (void) fillStringsValuesFromText: (NSString *) text {
    [self.stringsDict removeAllObjects];
    
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
            
            [self.stringsDict setObject:propertyStrValue forKey:propertyName];
        }
    }];
}

- (void) updatePropertyValueOrMakeItDefault: (CTProperty *) property { // and appent to text for dev mode
    
    NSString *strValInConfig = [self.stringsDict objectForKey:property.name];
    if (strValInConfig) {
        [property fromString:strValInConfig];
    } else { 

        property.value = property.defaultValue;
        [self.stringsDict setObject:property.toString forKey:property.name];
        
        if (self.mode == CTConfigurationMode) {
            
            NSString *textLine = [NSString stringWithFormat:@"\n%@ = %@", property.name, [property toString]];
            [self.panelController appendText:textLine];
            
        } else { // production mode
            NSLog(@"Warning: Property %@ has no value in config, use default value", property.name);
        }
        
    }
}

- (void) reReadConfigTextIfHasUntrackedModifications {
    if (self.panelController.textHasModifications) {
        [self fillStringsValuesFromText:self.panelController.text];
        self.panelController.textHasModifications = NO;
    }
    [self.propertiesDict enumerateKeysAndObjectsUsingBlock:^(NSString* name, CTProperty *property, BOOL *stop) {
        [self updatePropertyValueOrMakeItDefault:property];
    }];
}

- (void) startSceneWithName: (NSString *) sceneName {
    if (self.currentScene) {
        [self.currentScene stopScene];
    }
    self.currentScene = [self.sceneManager sceneByName:sceneName];
    [self.currentScene startScene];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:sceneName forKey:CT_DEFAULT_SCENE_NAME_KEY];
    [ud synchronize];

}

#pragma mark - Delegate

- (void) newSceneChoosed: (NSString *) sceneName {
    [self startSceneWithName:sceneName];
}

- (void) save {
    [self reReadConfigTextIfHasUntrackedModifications];
    
    NSURL *confFileUrl = [NSURL fileURLWithPath:self.confFilePath];
    NSError *error;
    
    if (![self.panelController.text writeToURL:confFileUrl atomically:NO encoding:NSUTF8StringEncoding error:&error]) {
        NSLog(@"Error while trying to create conf file %@: %@", self.confFilePath, [error localizedDescription]);
    }
    
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
        self.panelController = [[CTPanelController alloc] init];
        self.panelController.delegate = self;
        
        _properties = [NSMutableArray array];
        _propertiesDict = [[NSMutableDictionary alloc] init];
        _stringsDict = [[NSMutableDictionary alloc] init];
        _sceneManager = [[CTSceneManager alloc] init];
        _currentScene = nil;

    }
    return self;
}

- (void) startConfigurationModeWithConfigPath: (NSString *) path {
    self.mode = CTConfigurationMode;
    self.confFilePath = path;
    
    [self.panelController showWindow:self];
    [self.panelController setScenesNames:self.sceneManager.scenesNames];

    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:self.confFilePath]) {
        NSString *fileText = [NSString stringWithContentsOfFile:self.confFilePath encoding:NSUTF8StringEncoding error:nil];
        [self.panelController setText:fileText];
        [self reReadConfigTextIfHasUntrackedModifications];
    }
    
    if (self.sceneManager.scenesNames.count > 0) {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSString *defaultSceneName = [ud objectForKey:CT_DEFAULT_SCENE_NAME_KEY];

        id<CTScene> defaultScene = [self.sceneManager sceneByName:defaultSceneName];
        
        if (!defaultScene) {
            defaultSceneName = [self.sceneManager.scenesNames objectAtIndex:0];
        }
        
        [self.panelController selectSceneWithTitle:defaultSceneName];
        [self startSceneWithName:defaultSceneName];
    }
    
}

- (void) startNormalModeWithConfigPath: (NSString *) confpath {
    self.mode = CTNormalMode;
    self.confFilePath = confpath;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:self.confFilePath]) {
        NSLog(@"Error: Can't find %@. Use default values.", self.confFilePath);
        return;
    }
        
    NSString *fileText = [NSString stringWithContentsOfFile:self.confFilePath encoding:NSUTF8StringEncoding error:nil];
    [self fillStringsValuesFromText:fileText];
    
    // if already have properties, udpates them
    
    [self.propertiesDict enumerateKeysAndObjectsUsingBlock:^(NSString* name, CTProperty *property, BOOL *stop) {
        [self updatePropertyValueOrMakeItDefault:property];
    }];

}

- (void) unregisterObjectFromUpdates: (id) object {
    [self.propertiesDict enumerateKeysAndObjectsUsingBlock:^(NSString* name, CTProperty *property, BOOL *stop) {
        [property removeObjectFromUpdatesTracking:object];
    }];
}

#pragma mark Properties

- (void) registerPropery: (CTProperty *) property {
    
    CTProperty *registeredProperty = [self.propertiesDict objectForKey:property.name];
    if (!registeredProperty) {
        [self.propertiesDict setObject:property forKey:property.name];
    } else {
        if (registeredProperty.class != property.class) {
            [NSException raise:@"One name for different properties types" format:@"Property %@ has multiple types simultaneously", property.name];
        }
        
        [registeredProperty addObjectThatTracksUpdates:[property firstObjectThatTracksUpdates]]; // it just one when we register new property
    }
    
    if (self.mode == CTNormalMode) {
        [self updatePropertyValueOrMakeItDefault:property];
    } else {
        [self reReadConfigTextIfHasUntrackedModifications]; 
    }
}

- (double) declareDoubleInObject: (id) object withName: (NSString *) name defaultValue:(CGFloat) defaultVal {

    CTDoubleProperty *property = [[CTDoubleProperty alloc] init];
    property.name = name;
    property.defaultValue = [NSNumber numberWithFloat:defaultVal];
    [property addObjectThatTracksUpdates:object];
    
    [self registerPropery:property];

    CTProperty *assignedProperty = [self.propertiesDict objectForKey:name];
    double currentValue = [assignedProperty.value doubleValue]; 
    return currentValue;
}

- (NSInteger) declareIntegerInObject: (id) object withName: (NSString *) name defaultValue:(NSInteger) defaultVal {
    
    CTIntegerProperty *property = [[CTIntegerProperty alloc] init];
    property.name = name;
    property.defaultValue = [NSNumber numberWithInteger:defaultVal];
    [property addObjectThatTracksUpdates:object];
    
    [self registerPropery:property];
    
    CTProperty *assignedProperty = [self.propertiesDict objectForKey:name];
    double currentValue = [assignedProperty.value integerValue]; 
    return currentValue;
}

- (BOOL) declareBooleanInObject: (id) object withName: (NSString *) name defaultValue:(BOOL) defaultVal {
    CTBooleanProperty *property = [[CTBooleanProperty alloc] init];
    property.name = name;
    property.defaultValue = [NSNumber numberWithFloat:defaultVal];
    [property addObjectThatTracksUpdates:object];
    
    [self registerPropery:property];

    CTProperty *assignedProperty = [self.propertiesDict objectForKey:name];
    BOOL currentValue = [assignedProperty.value boolValue]; 
    return currentValue;
}

- (NSString *) declareEnumerateInObject: (id) object withName: (NSString *) name defaultValue:(NSString *) defaultVal possibleValues: (NSString *) possibleValue1, ...{
    CTEnumerateProperty *property = [[CTEnumerateProperty alloc] init];
    property.name = name;
    property.defaultValue = defaultVal;
    [property addObjectThatTracksUpdates:object];
    
    NSMutableArray *possibleValues = [[NSMutableArray alloc] init];
    va_list args;
    va_start(args, possibleValue1);
    for (NSString *arg = possibleValue1; arg != nil; arg = va_arg(args, NSString*))
    {
        [possibleValues addObject:arg];
    }
    va_end(args);
    property.possibleValues = possibleValues;
    
    [self registerPropery:property];

    CTProperty *assignedProperty = [self.propertiesDict objectForKey:name];
    return assignedProperty.value;
}

- (NSString *) declareStringInObject: (id) object withName: (NSString *) name defaultValue:(NSString *) defaultVal {
    CTStringProperty *property = [[CTStringProperty alloc] init];
    property.name = name;
    property.defaultValue = defaultVal;
    [property addObjectThatTracksUpdates:object];
    
    [self registerPropery:property];

    CTProperty *assignedProperty = [self.propertiesDict objectForKey:name];
    return assignedProperty.value;
}

- (NSArray *) declareDoubleArrayInObject: (id) object withName: (NSString *) name defaultValue:(NSArray *) defaultVal {
    CTDoubleArrayProperty *property = [[CTDoubleArrayProperty alloc] init];
    property.name = name;
    property.defaultValue = defaultVal;
    [property addObjectThatTracksUpdates:object];
    
    [self registerPropery:property];
    
    CTProperty *assignedProperty = [self.propertiesDict objectForKey:name];
    return assignedProperty.value;
}

- (NSSize) declareSizeInObject: (id) object withName: (NSString *) name defaultValue:(NSSize) defaultVal {
    CTSizeProperty *property = [[CTSizeProperty alloc] init];
    property.name = name;
    property.defaultValue = [NSValue valueWithSize:defaultVal];
    [property addObjectThatTracksUpdates:object];
    
    [self registerPropery:property];
    
    CTProperty *assignedProperty = [self.propertiesDict objectForKey:name];
    NSSize currentValue = [assignedProperty.value sizeValue]; 
    return currentValue;
}



@end
