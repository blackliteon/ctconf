//
//  MainScene.m
//  demoapp
//
//  Created by Dmitry Nikolaev on 07.07.12.
//  Copyright (c) 2012 cocotype.com. All rights reserved.
//

#import "MainScene.h"
#import "MainWindowController.h"

@interface MainScene ()

@property (strong, nonatomic) MainWindowController *mainWindowController;

@end

@implementation MainScene 

@synthesize mainWindowController = _mainWindowController;

- (NSString *) sceneName {
    return @"Main Scene";
}

- (void) startScene {
    
}

@end
