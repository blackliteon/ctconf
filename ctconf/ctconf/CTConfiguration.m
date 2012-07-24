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
#import "CTColorProperty.h"
#import "CTResourcePathProperty.h"
#import "CTPropertyManager.h"

#define CT_DEFAULT_SCENE_NAME_KEY @"CT_default_scene_name"

@interface CTConfiguration () <CTPanelControllerDelegate, CTResourcePathDelegate, CTPropertyManagerDelegate>

@property (strong, nonatomic) CTPanelController *panelController;

@property (strong, nonatomic) CTPropertyManager *propertyManager;

@property (strong, nonatomic) id<CTScene> currentScene;
@property (assign, nonatomic) CTMode mode;
@property (assign, nonatomic) BOOL useResourceFromBundle;

@end

@implementation CTConfiguration

static id sharedInstance = nil;

@synthesize confFilePath = _confFilePath;

@synthesize sceneManager = _sceneManager;
@synthesize panelController = _panelController;

@synthesize propertyManager = _propertyManager;

@synthesize currentScene = _currentScene;
@synthesize mode = _mode;
@synthesize useResourceFromBundle = _useResourceFromBundle;

- (void) propertyValueNotFound: (CTProperty *) property {
    if (self.mode == CTNormalMode) {
        NSLog(@"Warning (ctconf): Property '%@' value not set. Set to default (%@)", property.name, [property toString]);
    } else {
        NSString *textLine = [NSString stringWithFormat:@"\n%@ = %@", property.name, [property toString]];
        [self.panelController appendText:textLine];
    }
}

#pragma mark - Initializers

- (CTPropertyManager *) propertyManager {
    if (!_propertyManager) {
        _propertyManager = [[CTPropertyManager alloc] init];
    }
    return _propertyManager;
}

#pragma mark -

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

- (void) _reReadConfigFromConfigPanel {
    if (self.panelController.textHasModifications) {
        [self.propertyManager setConfigText:self.panelController.text];
        self.panelController.textHasModifications = NO;
    }
}

- (void) save {
    [self _reReadConfigFromConfigPanel];
    
    NSURL *confFileUrl = [NSURL fileURLWithPath:self.confFilePath];
    NSError *error;
    
    if (![self.panelController.text writeToURL:confFileUrl atomically:NO encoding:NSUTF8StringEncoding error:&error]) {
        NSLog(@"Error while trying to create conf file %@: %@", self.confFilePath, [error localizedDescription]);
    }
    
}

- (NSString *) absolutePathForResourceWithConfigPath: (NSString *) path {
    if (self.useResourceFromBundle) {
        NSString *lastComponent = [path lastPathComponent];
        NSString *mainBundlePath = [[NSBundle mainBundle] bundlePath];
        NSString *resourcePath = [NSString stringWithFormat:@"%@/Contents/Resources/%@", mainBundlePath, lastComponent];
        return resourcePath;

    } else {
        return path;
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
        
        _sceneManager = [[CTSceneManager alloc] init];
        _currentScene = nil;
        self.mode = CTConfigurationMode;

    }
    return self;
}

- (void) startConfigurationModeWithConfigPath: (NSString *) path {
    self.mode = CTConfigurationMode;
    self.confFilePath = path;
    self.useResourceFromBundle = NO;
    
    [self.panelController showWindow:self];
    [NSApp activateIgnoringOtherApps:YES];
    
    [self.panelController setScenesNames:self.sceneManager.scenesNames];

    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:self.confFilePath]) {
        NSString *fileText = [NSString stringWithContentsOfFile:self.confFilePath encoding:NSUTF8StringEncoding error:nil];
        [self.panelController setText:fileText];
        [self _reReadConfigFromConfigPanel];
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

- (void) startNormalModeWithConfigPath: (NSString *) confpath useResourcesFromBundle: (BOOL) resourcesFromBundle {
    self.mode = CTNormalMode;
    self.confFilePath = confpath;
    self.useResourceFromBundle = resourcesFromBundle;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:self.confFilePath]) {
        NSLog(@"Error: Can't find %@. Use default values.", self.confFilePath);
        return;
    }
        
    NSString *fileText = [NSString stringWithContentsOfFile:self.confFilePath encoding:NSUTF8StringEncoding error:nil];
    [self.propertyManager setConfigText:fileText];
}

- (void) unregisterObjectFromUpdates: (id) object {
    [self.propertyManager unregisterObjectFromUpdates:object];
}

#pragma mark Properties

- (double) addDoubleProperty: (NSString *) propertyName toObject: (id) object key: (NSString *) key defaultValue: (CGFloat) defaultValue {

    CTDoubleProperty *property = [[CTDoubleProperty alloc] init];
    property.name = propertyName;
    property.defaultValue = [NSNumber numberWithFloat:defaultValue];
    [property addObjectThatTracksUpdates:object key:key];
    
    [self _reReadConfigFromConfigPanel];
    [self.propertyManager addProperty:property];

    CTProperty *assignedProperty = [self.propertyManager propertyByName:propertyName];
    double currentValue = [assignedProperty.value doubleValue]; 
    return currentValue;
}

- (NSInteger) addIntegerProperty: (NSString *) propertyName toObject: (id) object key: (NSString *) key defaultValue: (NSInteger) defaultValue {
    
    CTIntegerProperty *property = [[CTIntegerProperty alloc] init];
    property.name = propertyName;
    property.defaultValue = [NSNumber numberWithInteger:defaultValue];
    [property addObjectThatTracksUpdates:object key:key];
    
    [self _reReadConfigFromConfigPanel];
    [self.propertyManager addProperty:property];
    
    CTProperty *assignedProperty = [self.propertyManager propertyByName:propertyName];
    double currentValue = [assignedProperty.value integerValue]; 
    return currentValue;
}

- (BOOL) addBooleanProperty: (NSString *) propertyName toObject: (id) object key: (NSString *) key defaultValue: (BOOL) defaultValue {
    CTBooleanProperty *property = [[CTBooleanProperty alloc] init];
    property.name = propertyName;
    property.defaultValue = [NSNumber numberWithFloat:defaultValue];
    [property addObjectThatTracksUpdates:object key:key];
    
    [self _reReadConfigFromConfigPanel];
    [self.propertyManager addProperty:property];

    CTProperty *assignedProperty = [self.propertyManager propertyByName:propertyName];
    BOOL currentValue = [assignedProperty.value boolValue]; 
    return currentValue;
}

- (NSString *) addEnumerateProperty: (NSString *) propertyName toObject: (id) object key: (NSString *) key defaultValue: (NSString *) defaultValue possibleValues: (NSString *) possibleValue1, ... {
    CTEnumerateProperty *property = [[CTEnumerateProperty alloc] init];
    property.name = propertyName;
    property.defaultValue = defaultValue;
    [property addObjectThatTracksUpdates:object key:key];
    
    NSMutableArray *possibleValues = [[NSMutableArray alloc] init];
    va_list args;
    va_start(args, possibleValue1);
    for (NSString *arg = possibleValue1; arg != nil; arg = va_arg(args, NSString*))
    {
        [possibleValues addObject:arg];
    }
    va_end(args);
    property.possibleValues = possibleValues;
    
    [self _reReadConfigFromConfigPanel];
    [self.propertyManager addProperty:property];

    CTProperty *assignedProperty = [self.propertyManager propertyByName:propertyName];
    return assignedProperty.value;
}

- (NSString *) addStringProperty: (NSString *) propertyName toObject: (id) object key: (NSString *) key defaultValue: (NSString *) defaultValue {
    CTStringProperty *property = [[CTStringProperty alloc] init];
    property.name = propertyName;
    property.defaultValue = defaultValue;
    [property addObjectThatTracksUpdates:object key:key];
    
    [self _reReadConfigFromConfigPanel];
    [self.propertyManager addProperty:property];

    CTProperty *assignedProperty = [self.propertyManager propertyByName:propertyName];
    return assignedProperty.value;
}

- (NSArray *) addDoubleArrayProperty: (NSString *) propertyName toObject: (id) object key: (NSString *) key defaultValue: (NSArray *) defaultValue {
    CTDoubleArrayProperty *property = [[CTDoubleArrayProperty alloc] init];
    property.name = propertyName;
    property.defaultValue = defaultValue;
    [property addObjectThatTracksUpdates:object key:key];
    
    [self _reReadConfigFromConfigPanel];
    [self.propertyManager addProperty:property];
    
    CTProperty *assignedProperty = [self.propertyManager propertyByName:propertyName];
    return assignedProperty.value;
}

- (NSSize) addSizeProperty: (NSString *) propertyName toObject: (id) object key: (NSString *) key defaultValue: (NSSize) defaultValue {
    CTSizeProperty *property = [[CTSizeProperty alloc] init];
    property.name = propertyName;
    property.defaultValue = [NSValue valueWithSize:defaultValue];
    [property addObjectThatTracksUpdates:object key:key];
    
    [self _reReadConfigFromConfigPanel];
    [self.propertyManager addProperty:property];
    
    CTProperty *assignedProperty = [self.propertyManager propertyByName:propertyName];
    NSSize currentValue = [assignedProperty.value sizeValue]; 
    return currentValue;
}

- (NSColor *) addColorProperty: (NSString *) propertyName toObject: (id) object key: (NSString *) key defaultValue: (NSColor *) defaultValue {
    CTColorProperty *property = [[CTColorProperty alloc] init];
    property.name = propertyName;
    property.defaultValue = defaultValue;
    [property addObjectThatTracksUpdates:object key:key];
    
    [self _reReadConfigFromConfigPanel];
    [self.propertyManager addProperty:property];
    
    CTProperty *assignedProperty = [self.propertyManager propertyByName:propertyName];
    return assignedProperty.value;
}

- (NSString *) addResourcePathProperty: (NSString *) propertyName toObject: (id) object key: (NSString *) key defaultPath: (NSString *) defaultValue {
    CTResourcePathProperty *property = [[CTResourcePathProperty alloc] init];
    property.name = propertyName;
    property.defaultValue = defaultValue;
    property.delegate = self;
    [property addObjectThatTracksUpdates:object key:key];
    
    [self _reReadConfigFromConfigPanel];
    [self.propertyManager addProperty:property];
    
    CTProperty *assignedProperty = [self.propertyManager propertyByName:propertyName];
    return assignedProperty.value;
}

// properties with listeners

- (double) addDoubleProperty:(NSString *)propertyName propertyListener:(id<CTPropertyListener>)listener defaultValue:(CGFloat)defaultValue alwaysInConfig: (BOOL) alwaysInConfig {

    // todo: implement alwaysInConfig
    
    CTDoubleProperty *property = [[CTDoubleProperty alloc] init];
    property.name = propertyName;
    property.defaultValue = [NSNumber numberWithFloat:defaultValue];
    [property addPropertyListener:listener];
    
    [self _reReadConfigFromConfigPanel];
    [self.propertyManager addProperty:property];
    
    CTProperty *assignedProperty = [self.propertyManager propertyByName:propertyName];
    double currentValue = [assignedProperty.value doubleValue]; 
    return currentValue;

}

- (NSColor *) addColorProperty: (NSString *) propertyName propertyListener:(id<CTPropertyListener>)listener  defaultValue:(NSColor *)defaultValue optional: (BOOL) optional defaultPropertyName: (NSString *) defaultProperty {
    CTColorProperty *property = [[CTColorProperty alloc] init];
    property.name = propertyName;
    property.defaultValue = defaultValue;
//    [property addObjectThatTracksUpdates:object key:key];
    [property addPropertyListener:listener];
    
    [self _reReadConfigFromConfigPanel];
    [self.propertyManager addProperty:property];
    
    CTProperty *assignedProperty = [self.propertyManager propertyByName:propertyName];
    return assignedProperty.value;
}



@end
