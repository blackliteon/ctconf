//
//  CTScene.h
//  ctconf
//
//  Created by Dmitry Nikolaev on 07.07.12.
//  Copyright (c) 2012 cocotype.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CTScene <NSObject>

- (NSString *) sceneName;

- (void) startScene;
- (void) stopScene;

@end
