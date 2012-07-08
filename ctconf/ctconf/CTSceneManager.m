//
//  CTSceneManager.m
//  ctconf
//
//  Created by Dmitry Nikolaev on 07.07.12.
//  Copyright (c) 2012 cocotype.com. All rights reserved.
//

#import "CTSceneManager.h"

@interface CTSceneManager ()

@property (strong, nonatomic) NSMutableArray *scenes;

@end

@implementation CTSceneManager

@synthesize scenes = _scenes;

- (id)init {
    self = [super init];
    if (self) {
        _scenes = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void) addScene: (id<CTScene>) scene {
    [self.scenes addObject:scene];
}

- (NSArray *) scenesNames {
    NSMutableArray *result = [NSMutableArray array];
    
    for (id<CTScene> scene in self.scenes) {
        [result addObject:scene.sceneName];
    }
    
    return result;
}

- (id<CTScene>) sceneByName: (NSString *) sceneName {
    for (id<CTScene> scene in self.scenes) {
        if ([scene.sceneName isEqualToString:sceneName]) {
            return scene;
        }
    }
    return nil;
}



@end
