//
//  AGraphicButton.m
//  WriteBoxLib
//
//  Created by Dmitry Nikolaev on 18.04.12.
//  Copyright (c) 2012 Apprium. All rights reserved.
//

#import "AGraphicButton.h"
#import <objc/message.h>

@implementation AGraphicButton
@synthesize delegate, onStateImage, offStateImage, clickedStateImage, imageRatio, disabledImage;
@synthesize buttonType, state, debugFrame;
@synthesize overImage;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        buttonType = NSMomentaryPushButton;
        state = NSOffState;
        mouseDown = NO;
        enabled = YES;
        debugFrame = NO;
        over = NO;
        overImage = nil;
        activeSize = NSZeroSize;
        
        // tracking area
        
        NSTrackingAreaOptions focusTrackingAreaOptions = NSTrackingActiveInActiveApp;
        focusTrackingAreaOptions |= NSTrackingMouseEnteredAndExited;
        
        focusTrackingArea = [[NSTrackingArea alloc] initWithRect:NSZeroRect
                                                                         options:focusTrackingAreaOptions owner:self userInfo:nil];
        [self addTrackingArea:focusTrackingArea];
    }
    
    return self;
}

- (void) setImagesFromPath: (NSString *) path {
//    NSString *defaultPath = [NSString stringWithFormat:@"%@.png"];
}

- (void) setActiveSize: (NSSize) _activeSize {
    
    if (_activeSize.width == 0 || _activeSize.height == 0) {
        _activeSize = self.bounds.size;
    }
    
    activeSize = _activeSize;
    
    CGFloat centerX = self.frame.size.width / 2;
    CGFloat centerY = self.frame.size.height / 2;
    
    CGFloat imageWidth = _activeSize.width * imageRatio;
    CGFloat imageHeight = _activeSize.height * imageRatio;
    
    CGFloat imageX = centerX - imageWidth / 2;
    CGFloat imageY = centerY - imageHeight / 2; // square, so use it for height
    
    trackingRect = NSMakeRect(imageX, imageY, imageWidth, imageHeight);
    
    [self removeTrackingArea:focusTrackingArea];
    
    NSTrackingAreaOptions focusTrackingAreaOptions = NSTrackingActiveInActiveApp;
    focusTrackingAreaOptions |= NSTrackingMouseEnteredAndExited;
    
    focusTrackingArea = [[NSTrackingArea alloc] initWithRect:trackingRect
                                                     options:focusTrackingAreaOptions owner:self userInfo:nil];
    [self addTrackingArea:focusTrackingArea];
    
}

- (void)updateTrackingAreas {
    [self setActiveSize:activeSize];
}


- (void)drawRect:(NSRect)dirtyRect
{
//    return;
    
    if (debugFrame) {
        [[NSColor redColor] setFill];
        NSRectFill(NSMakeRect(0, 0, self.frame.size.width, self.frame.size.height));

        [[NSColor blueColor] setFill];
        NSRectFill(NSMakeRect(2, 2, self.frame.size.width-4, self.frame.size.height-4));

        [[NSColor yellowColor] setFill];
        NSRectFill(trackingRect);
    
    }
    
    
    NSImage *imageToDraw;
    
    if (buttonType == NSPushOnPushOffButton) {
        if (state == NSOnState) {
            imageToDraw = onStateImage;
        } else {
            imageToDraw = offStateImage;
        }
    }
    
    if (buttonType == NSMomentaryPushButton) {
        imageToDraw = offStateImage;
        
        if (mouseDown && clickedStateImage != nil) {
            imageToDraw = clickedStateImage;
        } else {
            if (over && overImage != nil) {
                imageToDraw = overImage;
            }
        }
    }
    
    // set disabled if present
    
    if (disabledImage != nil && !enabled) {
        imageToDraw = disabledImage;
    }
    
    CGFloat centerX = self.frame.size.width / 2;
    CGFloat centerY = self.frame.size.height / 2;
    
    CGFloat imageWidth = imageToDraw.size.width * imageRatio;
    CGFloat imageHeight = imageToDraw.size.height * imageRatio;
    
    CGFloat imageX = centerX - imageWidth / 2;
    CGFloat imageY = centerY - imageHeight / 2; // square, so use it for height
    
    
    [imageToDraw drawInRect:NSMakeRect(imageX, imageY, imageWidth, imageHeight) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
}

- (void) setState:(NSCellStateValue) _state {
    state = _state;
    [self setNeedsDisplay:YES];
}

- (void)mouseDown:(NSEvent *)event
{
    if (!enabled) {
        return;
    }
    
//    if (event.clickCount > 1) {
//        return;
//    }
    
    if (state == NSOffState) {
        self.state = NSOnState;
    } else {
        self.state = NSOffState;
    }
    mouseDown = YES;
    [self setNeedsDisplay:YES];
    
    objc_msgSend(_target, _action, self);
}

- (void) mouseUp:(NSEvent *)theEvent {
    mouseDown = NO;
    [self setNeedsDisplay:YES];
}

- (void)setAction:(SEL)aSelector {
    _action = aSelector;
}

- (void)setTarget:(id)anObject {
    _target = anObject;
}

- (void) setEnabled: (BOOL) _enabled {
    enabled = _enabled;
    [self setNeedsDisplay:YES];
}
- (BOOL) isEnabled {
    return enabled;
}

- (void) mouseEntered:(NSEvent *)theEvent {
    over = YES;
    [self setNeedsDisplay:YES];
    if ([delegate respondsToSelector:@selector(mouseEntered:)]) {
        [delegate mouseEntered:self];
    }
}

- (void) mouseExited:(NSEvent *)theEvent {
    over = NO;
    mouseDown = NO;
    [self setNeedsDisplay:YES];
    if ([delegate respondsToSelector:@selector(mouseExited:)]) {
        [delegate mouseExited:self];
    }
}

- (void) mouseDragged:(NSEvent *)theEvent {
    if ([delegate respondsToSelector:@selector(mouseDragged:sender:)]) {
        [delegate mouseDragged:theEvent sender:self];
    }
}

- (BOOL) mouseDownCanMoveWindow {
    return NO;
}

@end
