//
//  CTPanelController.h
//  ctconf
//
//  Created by Dmitry Nikolaev on 06.07.12.
//  Copyright (c) 2012 cocotype.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CTPanel.h"

@protocol CTPanelControllerDelegate <NSObject>
    
- (void) newSceneChoosed: (NSString *) sceneName;
- (void) save;

@end


@interface CTPanelController : NSWindowController

@property (strong, nonatomic) NSArray *scenesNames;
@property (strong, nonatomic) id<CTPanelControllerDelegate> delegate;
@property (assign, nonatomic) BOOL textHasModifications;

- (void) setText: (NSString *) text;
- (void) appendText: (NSString *) text;
- (NSString *) text;

@end
