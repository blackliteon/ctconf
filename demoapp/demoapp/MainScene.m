//
//  MainScene.m
//  demoapp
//
//  Created by Dmitry Nikolaev on 07.07.12.
//  Copyright (c) 2012 cocotype.com. All rights reserved.
//

#import "MainScene.h"
#import "MainWindowController.h"

#define APP_MAIN_SCENE_WINDOW_COORD_KEY @"APP_MAIN_SCENE_WINDOW_COORD_KEY"

@interface MainScene ()

@property (strong, nonatomic) MainWindowController *mainWindowController;

@end

@implementation MainScene 

@synthesize mainWindowController = _mainWindowController;

- (id)init {
    self = [super init];
    if (self) {
        _mainWindowController = [[MainWindowController alloc] init];
    }
    return self;
}

- (NSString *) sceneName {
    return @"Main Scene";
}

- (void) startScene {
    [self.mainWindowController setWindowFrameAutosaveName:APP_MAIN_SCENE_WINDOW_COORD_KEY];
    [self.mainWindowController showWindow:self];
}

- (void) stopScene {
    [self.mainWindowController close];
}


@end
