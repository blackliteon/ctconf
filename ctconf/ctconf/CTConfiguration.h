//
//  CTConfiguration.h
//  ctconf
//
//  Created by Dmitry Nikolaev on 05.07.12.
//  Copyright (c) 2012 cocotype.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CTPanel.h"
#import "CTSceneManager.h"
#import "CTPropertyListener.h"

enum {
    CTNormalMode,
    CTConfigurationMode
};

typedef NSInteger CTMode;

@interface CTConfiguration : NSObject 


- (double) addDoubleProperty: (NSString *) propertyName toObject: (id) object key: (NSString *) key defaultValue: (CGFloat) defaultValue;

- (NSInteger) addIntegerProperty: (NSString *) propertyName toObject: (id) object key: (NSString *) key defaultValue: (NSInteger) defaultValue;

- (BOOL) addBooleanProperty: (NSString *) propertyName toObject: (id) object key: (NSString *) key defaultValue: (BOOL) defaultValue;

- (NSString *) addStringProperty: (NSString *) propertyName toObject: (id) object key: (NSString *) key defaultValue: (NSString *) defaultValue;

- (NSString *) addEnumerateProperty: (NSString *) propertyName toObject: (id) object key: (NSString *) key defaultValue: (NSString *) defaultValue possibleValues: (NSString *) possibleValue1, ...;

- (NSArray *) addDoubleArrayProperty: (NSString *) propertyName toObject: (id) object key: (NSString *) key defaultValue: (NSArray *) defaultValue;

- (NSSize) addSizeProperty: (NSString *) propertyName toObject: (id) object key: (NSString *) key defaultValue: (NSSize) defaultValue;

- (NSColor *) addColorProperty: (NSString *) propertyName toObject: (id) object key: (NSString *) key defaultValue: (NSColor *) defaultValue;

- (NSString *) addResourcePathProperty: (NSString *) propertyName toObject: (id) object key: (NSString *) key defaultPath: (NSString *) defaultValue;

// properties with listeners

- (double) addDoubleProperty:(NSString *)propertyName propertyListener:(id<CTPropertyListener>)listener defaultValue:(CGFloat)defaultValue;


- (void) startConfigurationModeWithConfigPath: (NSString *) path;
- (void) startNormalModeWithConfigPath: (NSString *) path useResourcesFromBundle: (BOOL) resourcesFromBundle;
- (void) unregisterObjectFromUpdates: (id) object;
+ (CTConfiguration *) sharedInstance;

@property (copy, nonatomic) NSString *confFilePath;
@property (strong, nonatomic) CTSceneManager *sceneManager;

@end
