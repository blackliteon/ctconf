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

@interface CTConfiguration () <CTPanelControllerDelegate>

@property (strong, nonatomic) NSMutableArray *properties;
@property (strong, nonatomic) CTPanelController *panelController;

@property (strong, nonatomic) NSMutableDictionary *propertiesDict;
@property (strong, nonatomic) NSMutableDictionary *stringsDict;

@end

@implementation CTConfiguration

static id sharedInstance = nil;

@synthesize confFilePath = _confFilePath;

@synthesize properties = _properties;
@synthesize panelController = _panelController;
@synthesize sceneManager = _sceneManager;

@synthesize propertiesDict = _propertiesDict;
@synthesize stringsDict = _stringsDict;

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

- (void) reReadConfigTextIfHasUntrackedModifications {
    if (self.panelController.textHasModifications) {
        [self fillStringsValuesFromText:self.panelController.text];
        [self.propertiesDict enumerateKeysAndObjectsUsingBlock:^(NSString* name, CTProperty *property, BOOL *stop) {
            NSString *strValue = [self.stringsDict objectForKey:name];
            [property fromString:strValue];
        }];
        self.panelController.textHasModifications = NO;
    }
}

- (void) registerPropery: (CTProperty *) property {
    [self reReadConfigTextIfHasUntrackedModifications];
    
    [self.propertiesDict setObject:property forKey:property.name];
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

#pragma mark - Delegate

- (void) newSceneChoosed: (NSString *) sceneName {
    NSLog(@"Scene %@ choosed", sceneName);
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
        CTConfiguration *conf = sharedInstance;
        conf.sceneManager = [[CTSceneManager alloc] init];
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

    }
    return self;
}

- (void) startDevelopmentVersion {
    [self.panelController setScenesNames:self.sceneManager.scenesNames];
    [self.panelController showWindow:self];

    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:self.confFilePath]) {
        NSString *fileText = [NSString stringWithContentsOfFile:self.confFilePath encoding:NSUTF8StringEncoding error:nil];
        [self.panelController setText:fileText];
        [self reReadConfigTextIfHasUntrackedModifications];
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
