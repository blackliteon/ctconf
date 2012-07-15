//
//  AGraphicButton.h
//  WriteBoxLib
//
//  Created by Dmitry Nikolaev on 18.04.12.
//  Copyright (c) 2012 Apprium. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AGraphicButtonDelegate.h"

@interface AGraphicButton : NSView {
    NSSize activeSize;
    NSTrackingArea *focusTrackingArea;
    NSRect trackingRect;
    
    NSImage *onStateImage;
    NSImage *offStateImage;
    NSImage *clickedStateImage;
    NSImage *disabledImage;
    NSImage *overImage;
    
    __weak id<AGraphicButtonDelegate> delegate;
    
    CGFloat imageRatio;
    
    NSButtonType buttonType;
    NSCellStateValue state;
    SEL _action;
    id _target;
    
    
    BOOL mouseDown;
    BOOL enabled;
    BOOL debugFrame;
    BOOL over;
}

@property (strong) NSImage *onStateImage;
@property (strong) NSImage *offStateImage;
@property (strong) NSImage *clickedStateImage;
@property (strong) NSImage *disabledImage;
@property (strong) NSImage *overImage;

@property (weak) id<AGraphicButtonDelegate> delegate;

@property (assign) CGFloat imageRatio;

@property (assign) NSButtonType buttonType;
@property (readonly) NSCellStateValue state;

@property (assign) BOOL debugFrame;

- (void) setState:(NSCellStateValue)state;

- (void)setAction:(SEL)aSelector;
- (void)setTarget:(id)anObject;

- (void) setEnabled: (BOOL) enabled;
- (BOOL) isEnabled;

- (void) setActiveSize: (NSSize) _activeSize;
- (void) setImagesFromPath: (NSString *) path;

@end
