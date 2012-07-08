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

#define CT_DEFAULT_SCENE_NAME_KEY @"CT_default_scene_name"

@interface CTConfiguration () <CTPanelControllerDelegate>

@property (strong, nonatomic) NSMutableArray *properties;
@property (strong, nonatomic) CTPanelController *panelController;

@property (strong, nonatomic) NSMutableDictionary *propertiesDict;
@property (strong, nonatomic) NSMutableDictionary *stringsDict;

@property (strong, nonatomic) id<CTScene> currentScene;

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

- (void) updatePropertyValueOrMakeItDefault: (CTProperty *) property { // and appent to text
    NSString *strValInConfig = [self.stringsDict objectForKey:property.name];
    if (strValInConfig) {
        [property fromString:strValInConfig];
    } else { // register string value
        property.value = property.defaultValue;
        [self.stringsDict setObject:property.toString forKey:property.name];
        
        NSString *textLine = [NSString stringWithFormat:@"\n%@ = %@", property.name, [property toString]];
        [self.panelController appendText:textLine];
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

- (void) registerPropery: (CTProperty *) property {
    
    [self.propertiesDict setObject:property forKey:property.name];
    [self reReadConfigTextIfHasUntrackedModifications]; 
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

- (void) startDevelopmentVersion {
    
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

- (void) startProductionVersion {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSArray *pathComponents = [[self.confFilePath lastPathComponent] componentsSeparatedByString:@"."];
    NSString *fileName = [pathComponents objectAtIndex:0];
    NSString *fileExtension = [pathComponents objectAtIndex:1];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:fileExtension];
    if ([fileManager fileExistsAtPath:path]) {
//        NSString *confText = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
//        [self loadPropertiesValuesFromText:confText unusedProperties:nil];
        NSLog(@"startProductionVersion not yet fully implemented");
    } else {
        NSLog(@"Error: Can't find ct.conf in main bundle: %@. Use default values.", path);
    }
}

#pragma mark Properties

- (double) declareDoubleInObject: (id) object withName: (NSString *) name defaultValue:(CGFloat) defaultVal {

    CTDoubleProperty *property = [[CTDoubleProperty alloc] init];
    property.name = name;
    property.defaultValue = [NSNumber numberWithFloat:defaultVal];
    property.objectOwnedProperty = object;
    
    [self registerPropery:property];
    double currentValue = [property.value doubleValue]; 
    return currentValue;
}

- (BOOL) declareBooleanInObject: (id) object withName: (NSString *) name defaultValue:(BOOL) defaultVal {
    CTBooleanProperty *property = [[CTBooleanProperty alloc] init];
    property.name = name;
    property.defaultValue = [NSNumber numberWithFloat:defaultVal];
    property.objectOwnedProperty = object;
    
    [self registerPropery:property];
    BOOL currentValue = [property.value boolValue]; 
    return currentValue;
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
    
    [self registerPropery:property];
    return property.value;
}




@end
