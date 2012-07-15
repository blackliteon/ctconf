//
//  AGraphicButtonDelegate.h
//  WriteBoxLib
//
//  Created by Dmitry Nikolaev on 08.05.12.
//  Copyright (c) 2012 Apprium. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AGraphicButtonDelegate <NSObject>

@optional

- (void) mouseEntered: (id) sender;
- (void) mouseExited: (id) sender;

- (void) mouseDragged: (NSEvent *) theEvent sender: (id) sender;

@end
