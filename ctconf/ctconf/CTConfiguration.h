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

- (double) declareDoubleInObject: (id) object withName: (NSString *) name defaultValue:(CGFloat) defaultVal;
- (NSInteger) declareIntegerInObject: (id) object withName: (NSString *) name defaultValue:(NSInteger) defaultVal;
- (BOOL) declareBooleanInObject: (id) object withName: (NSString *) name defaultValue:(BOOL) defaultVal;
- (NSString *) declareEnumerateInObject: (id) object withName: (NSString *) name defaultValue:(NSString *) defaultVal possibleValues: (NSString *) possibleValue1, ...;
- (NSString *) declareStringInObject: (id) object withName: (NSString *) name defaultValue:(NSString *) defaultVal;
- (NSArray *) declareDoubleArrayInObject: (id) object withName: (NSString *) name defaultValue:(NSArray *) defaultVal;
- (NSSize) declareSizeInObject: (id) object withName: (NSString *) name defaultValue:(NSSize) defaultVal;

// 

- (void) startConfigurationModeWithConfigPath: (NSString *) path;
- (void) startNormalModeWithConfigPath: (NSString *) path;

- (void) unregisterObjectFromUpdates: (id) object;

+ (CTConfiguration *) sharedInstance;

@property (copy, nonatomic) NSString *confFilePath;
@property (strong, nonatomic) CTSceneManager *sceneManager;

@end
