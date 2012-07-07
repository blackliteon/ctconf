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



@end
