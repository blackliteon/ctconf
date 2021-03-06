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
#import "CTUnicharProperty.h"
#import "CTFontProperty.h"
#import "CTEdgeInsetsProperty.h"
#import "NSValue+EdgeInsets.h"
#import "CTRectProperty.h"

#define CT_DEFAULT_SCENE_NAME_KEY @"CT_default_scene_name"


@interface CTConfiguration () <CTPanelControllerDelegate, CTResourcePathDelegate, CTPropertyManagerDelegate>

@property (strong, nonatomic) CTPanelController *panelController;
@property (strong, nonatomic) CTPropertyManager *propertyManager;
@property (strong, nonatomic) CTSceneManager *sceneManager;

@property (strong, nonatomic) id<CTScene> currentScene;

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

#pragma mark - Initializers

- (CTPropertyManager *) propertyManager {
    if (!_propertyManager) {
        _propertyManager = [[CTPropertyManager alloc] init];
        _propertyManager.delegate = self;
    }
    return _propertyManager;
}

- (CTSceneManager *) sceneManager {
    if (!_sceneManager) {
        _sceneManager = [[CTSceneManager alloc] init];
    }
    return _sceneManager;
}

- (CTPanelController *) panelController {
    if (!_panelController) {
        _panelController = [[CTPanelController alloc] init];
        _panelController.delegate = self;
    }
    return _panelController;
}

#pragma mark - Configuration panel

- (void) _startSceneWithName: (NSString *) sceneName {
    
    // switch scene
    
    if (self.currentScene) {
        [self.currentScene stopScene];
    }
    self.currentScene = [self.sceneManager sceneByName:sceneName];
    [self.currentScene startScene];
    
    // store to user defaults
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:sceneName forKey:CT_DEFAULT_SCENE_NAME_KEY];
    [ud synchronize];

}

- (void) newSceneChoosed: (NSString *) sceneName {
    [self _startSceneWithName:sceneName];
}

- (void) _reReadConfigFromConfigPanel {
    if (self.panelController.textHasModifications) {
        [self.propertyManager setConfigText:self.panelController.text];
        self.panelController.textHasModifications = NO;
    }
}

- (void) save {
    [self _reReadConfigFromConfigPanel];
    
    if (self.confFilePath) {
    
        NSURL *confFileUrl = [NSURL fileURLWithPath:self.confFilePath];
        NSError *error;
        
        if (![self.panelController.text writeToURL:confFileUrl atomically:NO encoding:NSUTF8StringEncoding error:&error]) {
            NSLog(@"Error while trying to create conf file %@: %@", self.confFilePath, [error localizedDescription]);
        }
    }
}

- (NSString *) normalizePath: (NSString *) path {
    if (self.useResourceFromBundle) {
        NSString *lastComponent = [path lastPathComponent];
        NSString *mainBundlePath = [[NSBundle mainBundle] bundlePath];
        NSString *resourcePath = [NSString stringWithFormat:@"%@/Contents/Resources/%@", mainBundlePath, lastComponent];
        return resourcePath;
        
    } else {
        
        if (![path hasPrefix:@"/"]) {
            NSString * absolutePath = [NSString stringWithFormat:@"%@/%@", [self.confFilePath stringByDeletingLastPathComponent], path];
            return absolutePath;
        }
        
        return path;
    }
}


#pragma mark - Misc

- (NSString *) absolutePathForResourceWithConfigPath: (NSString *) path {
    return [self normalizePath:path];
}

- (void) propertyValueNotFound: (CTProperty *) property {
    if (self.mode == CTNormalMode) {
//        NSLog(@"Warning (ctconf): Property '%@' value not set. Set to default (%@)", property.name, [property toString]);
    } else {
        NSString *textLine = [NSString stringWithFormat:@"\n%@ = %@", property.name, [property toString]];
        [self.panelController appendText:textLine];
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
        _currentScene = nil;
        self.mode = CTConfigurationMode;
    }
    return self;
}

- (void) showConfigurationPanel {
    [self.panelController showWindow:self];
    
    if (self.propertyManager.configText) {
        [self.panelController setText:self.propertyManager.configText];
        self.panelController.textHasModifications = NO;
    }
    
    [self.panelController setScenesNames:self.sceneManager.scenesNames];
    if (self.sceneManager.scenesNames.count > 0) {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSString *defaultSceneName = [ud objectForKey:CT_DEFAULT_SCENE_NAME_KEY];
        
        id<CTScene> defaultScene = [self.sceneManager sceneByName:defaultSceneName];
        
        if (!defaultScene) {
            defaultSceneName = [self.sceneManager.scenesNames objectAtIndex:0];
        }
        
        [self.panelController selectSceneWithTitle:defaultSceneName];
        [self _startSceneWithName:defaultSceneName];
    }
    
    [NSApp activateIgnoringOtherApps:YES];

}

- (void) readConfig {
    
    if (!self.confFilePath) {
        return;
    }
    
    NSString *configText = nil;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:self.confFilePath]) {
        configText = [NSString stringWithContentsOfFile:self.confFilePath encoding:NSUTF8StringEncoding error:nil];
        
        [self.propertyManager setConfigText:configText];
    } else {
        NSLog(@"Warning (ctconf) : Can't find %@. Use default values.", self.confFilePath);
    }

}

- (void) unregisterObjectFromUpdates: (id) object {
    [self.propertyManager unregisterObjectFromUpdates:object];
}

- (id) valueOfProperty: (NSString *) propertyName {
    CTProperty *property = [self.propertyManager propertyByName:propertyName];
    return property.value;
}

#pragma mark Properties

- (CTProperty *) _registerProperty: (CTProperty *) property {
    if (self.mode == CTConfigurationMode) {
        [self _reReadConfigFromConfigPanel];
    }
    [self.propertyManager addProperty:property];
    CTProperty *assignedProperty = [self.propertyManager propertyByName:property.name];
    return assignedProperty;
}

- (double) addDoubleProperty: (NSString *) propertyName toObject: (id) object key: (NSString *) key defaultValue: (CGFloat) defaultValue {

    CTDoubleProperty *property = [[CTDoubleProperty alloc] init];
    property.name = propertyName;
    property.defaultValue = [NSNumber numberWithFloat:defaultValue];
    [property addObjectThatTracksUpdates:object key:key];
    
    CTProperty *assignedProperty = [self _registerProperty:property];
    double currentValue = [assignedProperty.value doubleValue]; 
    return currentValue;
}

- (NSInteger) addIntegerProperty: (NSString *) propertyName toObject: (id) object key: (NSString *) key defaultValue: (NSInteger) defaultValue {
    
    CTIntegerProperty *property = [[CTIntegerProperty alloc] init];
    property.name = propertyName;
    property.defaultValue = [NSNumber numberWithInteger:defaultValue];
    [property addObjectThatTracksUpdates:object key:key];
    
    CTProperty *assignedProperty = [self _registerProperty:property];
    double currentValue = [assignedProperty.value integerValue]; 
    return currentValue;
}

- (BOOL) addBooleanProperty: (NSString *) propertyName toObject: (id) object key: (NSString *) key defaultValue: (BOOL) defaultValue {
    CTBooleanProperty *property = [[CTBooleanProperty alloc] init];
    property.name = propertyName;
    property.defaultValue = [NSNumber numberWithFloat:defaultValue];
    [property addObjectThatTracksUpdates:object key:key];
    
    CTProperty *assignedProperty = [self _registerProperty:property];
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
    
    CTProperty *assignedProperty = [self _registerProperty:property];
    return assignedProperty.value;
}

- (NSString *) addStringProperty: (NSString *) propertyName toObject: (id) object key: (NSString *) key defaultValue: (NSString *) defaultValue {
    CTStringProperty *property = [[CTStringProperty alloc] init];
    property.name = propertyName;
    property.defaultValue = defaultValue;
    [property addObjectThatTracksUpdates:object key:key];
    
    CTProperty *assignedProperty = [self _registerProperty:property];
    return assignedProperty.value;
}

- (NSArray *) addDoubleArrayProperty: (NSString *) propertyName toObject: (id) object key: (NSString *) key defaultValue: (NSArray *) defaultValue {
    CTDoubleArrayProperty *property = [[CTDoubleArrayProperty alloc] init];
    property.name = propertyName;
    property.defaultValue = defaultValue;
    [property addObjectThatTracksUpdates:object key:key];
    
    CTProperty *assignedProperty = [self _registerProperty:property];
    return assignedProperty.value;
}

- (NSSize) addSizeProperty: (NSString *) propertyName toObject: (id) object key: (NSString *) key defaultValue: (NSSize) defaultValue {
    CTSizeProperty *property = [[CTSizeProperty alloc] init];
    property.name = propertyName;
    property.defaultValue = [NSValue valueWithSize:defaultValue];
    [property addObjectThatTracksUpdates:object key:key];
    
    CTProperty *assignedProperty = [self _registerProperty:property];
    NSSize currentValue = [assignedProperty.value sizeValue]; 
    return currentValue;
}

- (NSColor *) addColorProperty: (NSString *) propertyName toObject: (id) object key: (NSString *) key defaultValue: (NSColor *) defaultValue {
    CTColorProperty *property = [[CTColorProperty alloc] init];
    property.name = propertyName;
    property.defaultValue = defaultValue;
    [property addObjectThatTracksUpdates:object key:key];
    
    CTProperty *assignedProperty = [self _registerProperty:property];
    return assignedProperty.value;
}

- (NSString *) addResourcePathProperty: (NSString *) propertyName toObject: (id) object key: (NSString *) key defaultPath: (NSString *) defaultValue {
    CTResourcePathProperty *property = [[CTResourcePathProperty alloc] init];
    property.name = propertyName;
    property.defaultValue = defaultValue;
    property.delegate = self;
    [property addObjectThatTracksUpdates:object key:key];
    
    CTProperty *assignedProperty = [self _registerProperty:property];
    return [self normalizePath:assignedProperty.value];
}

- (NSFont *) addFontProperty: (NSString *) propertyName toObject: (id) object key: (NSString *) key defaultValue: (NSFont *) defaultValue {
    CTFontProperty *property = [[CTFontProperty alloc] init];
    property.name = propertyName;
    property.defaultValue = defaultValue;
    [property addObjectThatTracksUpdates:object key:key];
    
    CTProperty *assignedProperty = [self _registerProperty:property];
    return assignedProperty.value;
}

- (NSEdgeInsets) addEdgeInsetsProperty: (NSString *) propertyName toObject: (id) object key: (NSString *) key defaultValue: (NSEdgeInsets) defaultValue {
    CTEdgeInsetsProperty *property = [[CTEdgeInsetsProperty alloc] init];
    property.name = propertyName;
    property.defaultValue = [NSValue valueWithEdgeInsets:defaultValue];
    [property addObjectThatTracksUpdates:object key:key];
    
    CTProperty *assignedProperty = [self _registerProperty:property];
    NSEdgeInsets edgeInsets = [assignedProperty.value edgeInsetsValue];
    return edgeInsets;
}

- (CTButtonStyle *) addButtonStyleProperty: (NSString *) propertyName toObject: (id) object key: (NSString *) key defaultValue: (CTButtonStyle *) defaultValue {
    
    CTButtonStyleProperty *property = [[CTButtonStyleProperty alloc] init];
    property.name = propertyName;
    property.defaultValue = defaultValue;
    [property addObjectThatTracksUpdates:object key:key];
    
    CTProperty *assignedProperty = [self _registerProperty:property];
    return assignedProperty.transformedValue;
}

- (NSRect) addRectProperty: (NSString *) propertyName toObject: (id) object key: (NSString *) key defaultValue: (NSRect) defaultValue {
    CTRectProperty *property = [[CTRectProperty alloc] init];
    property.name = propertyName;
    property.defaultValue = [NSValue valueWithRect:defaultValue];
    [property addObjectThatTracksUpdates:object key:key];
    
    CTProperty *assignedProperty = [self _registerProperty:property];
    NSRect currentValue = [assignedProperty.value rectValue];
    return currentValue;
}


// properties with listeners

- (double) addDoubleProperty:(NSString *)propertyName propertyListener:(id<CTPropertyListener>)listener defaultValue:(CGFloat)defaultValue optional: (BOOL) optional masterPropertyName: (NSString *) masterPropertyName {

    CTDoubleProperty *property = [[CTDoubleProperty alloc] init];
    property.name = propertyName;
    property.defaultValue = [NSNumber numberWithFloat:defaultValue];
    property.optional = optional;
    property.masterPropertyName = masterPropertyName;
    
    [property addPropertyListener:listener];
    
    CTProperty *assignedProperty = [self _registerProperty:property];
    double currentValue = [assignedProperty.value doubleValue]; 
    return currentValue;

}

- (NSColor *) addColorProperty: (NSString *) propertyName propertyListener:(id<CTPropertyListener>)listener  defaultValue:(NSColor *)defaultValue optional: (BOOL) optional masterPropertyName: (NSString *) masterPropertyName {
    CTColorProperty *property = [[CTColorProperty alloc] init];
    property.name = propertyName;
    property.defaultValue = defaultValue;
    property.optional = optional;
    property.masterPropertyName = masterPropertyName;
    
    [property addPropertyListener:listener];
    
    CTProperty *assignedProperty = [self _registerProperty:property];
    return assignedProperty.value;
}

- (BOOL) addBooleanProperty:(NSString *)propertyName propertyListener:(id<CTPropertyListener>)listener defaultValue:(BOOL)defaultValue optional: (BOOL) optional masterPropertyName: (NSString *) masterPropertyName {
    CTBooleanProperty *property = [[CTBooleanProperty alloc] init];
    property.name = propertyName;
    property.defaultValue = [NSNumber numberWithFloat:defaultValue];
    property.optional = optional;
    property.masterPropertyName = masterPropertyName;

    [property addPropertyListener:listener];
    
    CTProperty *assignedProperty = [self _registerProperty:property];
    BOOL currentValue = [assignedProperty.value boolValue]; 
    return currentValue;

}

- (NSString *) addEnumerateProperty: (NSString *) propertyName propertyListener:(id<CTPropertyListener>) listener defaultValue: (NSString *) defaultValue optional: (BOOL) optional masterPropertyName: (NSString *) masterPropertyName possibleValues: (NSString *) possibleValue1, ... {
    
    CTEnumerateProperty *property = [[CTEnumerateProperty alloc] init];
    property.name = propertyName;
    property.defaultValue = defaultValue;
    property.optional = optional;
    property.masterPropertyName = masterPropertyName;
    
    [property addPropertyListener:listener];
    
    NSMutableArray *possibleValues = [[NSMutableArray alloc] init];
    va_list args;
    va_start(args, possibleValue1);
    for (NSString *arg = possibleValue1; arg != nil; arg = va_arg(args, NSString*))
    {
        [possibleValues addObject:arg];
    }
    va_end(args);
    property.possibleValues = possibleValues;
    
    CTProperty *assignedProperty = [self _registerProperty:property];
    return assignedProperty.value;
}

- (NSInteger) addIntegerProperty:(NSString *)propertyName propertyListener:(id<CTPropertyListener>)listener defaultValue:(NSInteger)defaultValue optional: (BOOL) optional masterPropertyName: (NSString *) masterPropertyName {

    CTIntegerProperty *property = [[CTIntegerProperty alloc] init];
    property.name = propertyName;
    property.defaultValue = [NSNumber numberWithInteger:defaultValue];
    property.optional = optional;
    property.masterPropertyName = masterPropertyName;
    
    [property addPropertyListener:listener];
    
    CTProperty *assignedProperty = [self _registerProperty:property];
    double currentValue = [assignedProperty.value integerValue]; 
    return currentValue;

}

- (unichar) addUnicharProperty:(NSString *)propertyName propertyListener:(id<CTPropertyListener>)listener defaultValue:(unichar)defaultValue optional: (BOOL) optional masterPropertyName: (NSString *) masterPropertyName {
    
    CTUnicharProperty *property = [[CTUnicharProperty alloc] init];
    property.name = propertyName;
    property.defaultValue = [NSNumber numberWithFloat:defaultValue];
    property.optional = optional;
    property.masterPropertyName = masterPropertyName;
    
    [property addPropertyListener:listener];
    
    CTProperty *assignedProperty = [self _registerProperty:property];
    unichar currentValue = [assignedProperty.value unsignedShortValue]; 
    return currentValue;

}

- (NSFont *) addFontProperty: (NSString *) propertyName propertyListener:(id<CTPropertyListener>)listener defaultValue: (NSFont *) defaultValue optional: (BOOL) optional masterPropertyName: (NSString *) masterPropertyName {
    
    CTFontProperty *property = [[CTFontProperty alloc] init];
    property.name = propertyName;
    property.defaultValue = defaultValue;
    property.optional = optional;
    property.masterPropertyName = masterPropertyName;
    
    [property addPropertyListener:listener];
    
    CTProperty *assignedProperty = [self _registerProperty:property];
    return assignedProperty.value;
}




@end
