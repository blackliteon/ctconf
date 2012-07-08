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

@interface CTConfiguration : NSObject 

- (double) declareDoubleInObject: (id) object withName: (NSString *) name defaultValue:(CGFloat) defaultVal;
- (BOOL) declareBooleanInObject: (id) object withName: (NSString *) name defaultValue:(BOOL) defaultVal;
- (NSString *) declareEnumerateInObject: (id) object withName: (NSString *) name defaultValue:(NSString *) defaultVal possibleValues: (NSString *) possibleValue1, ...;
- (NSString *) declareStringInObject: (id) object withName: (NSString *) name defaultValue:(NSString *) defaultVal;

- (void) startDevelopmentVersion;
- (void) startProductionVersion;

- (void) unregisterObjectFromUpdates: (id) object;

+ (CTConfiguration *) sharedInstance;

@property (copy, nonatomic) NSString *confFilePath;
@property (strong, nonatomic) CTSceneManager *sceneManager;

@end
