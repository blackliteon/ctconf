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

/*
- (double) declareDoubleInObject: (id) object withName: (NSString *) name defaultValue:(CGFloat) defaultVal;
- (NSInteger) declareIntegerInObject: (id) object withName: (NSString *) name defaultValue:(NSInteger) defaultVal;
- (BOOL) declareBooleanInObject: (id) object withName: (NSString *) name defaultValue:(BOOL) defaultVal;
- (NSString *) declareEnumerateInObject: (id) object withName: (NSString *) name defaultValue:(NSString *) defaultVal possibleValues: (NSString *) possibleValue1, ...;
- (NSString *) declareStringInObject: (id) object withName: (NSString *) name defaultValue:(NSString *) defaultVal;
- (NSArray *) declareDoubleArrayInObject: (id) object withName: (NSString *) name defaultValue:(NSArray *) defaultVal;
- (NSSize) declareSizeInObject: (id) object withName: (NSString *) name defaultValue:(NSSize) defaultVal;
*/
// 

- (void) startConfigurationModeWithConfigPath: (NSString *) path;
- (void) startNormalModeWithConfigPath: (NSString *) path;

- (void) unregisterObjectFromUpdates: (id) object;

+ (CTConfiguration *) sharedInstance;

@property (copy, nonatomic) NSString *confFilePath;
@property (strong, nonatomic) CTSceneManager *sceneManager;

@end
