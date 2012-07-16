//
//  CTPushOnPushOffButton.m
//  ctconf
//
//  Created by Dmitry Nikolaev on 16.07.12.
//  Copyright (c) 2012 cocotype.com. All rights reserved.
//

#import "CTPushOnPushOffButton.h"

enum {
    CTPushButtonImageStatePushedOff,
    CTPushButtonImageStateOverPushedOff,
    CTPushButtonImageStatePushedOn,
    CTPushButtonImageStateOverPushedOn,
    CTPushButtonImageStateClicked,
    CTPushButtonImageStateDisabled
};

typedef NSUInteger CTPushOnPushOffButtonImageState;

@interface CTPushOnPushOffButton ()

@property (strong, nonatomic) NSImage *pushedOffImage;
@property (strong, nonatomic) NSImage *overPushedOffImage;
@property (strong, nonatomic) NSImage *pushedOnImage;
@property (strong, nonatomic) NSImage *overPushedOnImage;
@property (strong, nonatomic) NSImage *clickedImage;
@property (strong, nonatomic) NSImage *disabledImage;

@property (assign, nonatomic) BOOL mouseEntered;
@property (assign, nonatomic) BOOL mouseDown;

@property (assign, nonatomic) CTPushOnPushOffButtonImageState imageState;
@property (strong, nonatomic) NSImage *drawnImage; // do not update this value for state update, use imageState
@property (strong, nonatomic) NSTrackingArea *trackingArea;

@end

@implementation CTPushOnPushOffButton

@synthesize identifier = _identifier;
@synthesize enabled = _enabled;
@synthesize pushed = _pushed;
@synthesize delegate = _delegate;

@synthesize pushedOffImage = _pushedOffImage;
@synthesize overPushedOffImage = _overPushedOffImage;
@synthesize pushedOnImage = _pushedOnImage;
@synthesize overPushedOnImage = _overPushedOnImage;
@synthesize clickedImage = _clickedImage;
@synthesize disabledImage = _disabledImage;

@synthesize mouseEntered = _mouseEntered;
@synthesize mouseDown = _mouseDown;

@synthesize imageState = _imageState;
@synthesize drawnImage = _drawnImage;
@synthesize trackingArea = _trackingArea;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.enabled = YES;
        self.mouseEntered = NO;
        self.pushed = NO;
    }
    
    return self;
}

- (void) setImagesFromPath: (NSString *) path {
    self.pushedOffImage = [[NSImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@_off.png", path]];
    self.overPushedOffImage = [[NSImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@_offover.png", path]];
    self.pushedOnImage = [[NSImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@_on.png", path]];
    self.overPushedOnImage = [[NSImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@_onover.png", path]];
    self.clickedImage = [[NSImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@_clicked.png", path]];
    self.disabledImage = [[NSImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@_disabled.png", path]];
}

#pragma mark - State setters

- (void) _updateImageState {
    
    if (!self.enabled) {
        [self setImageState:CTPushButtonImageStateDisabled];
        return;
    }
    
    if (self.mouseDown && self.mouseEntered) {
        [self setImageState:CTPushButtonImageStateClicked];
        return;
    }
    
    if (self.pushed) {
        if (self.mouseEntered) {
            [self setImageState:CTPushButtonImageStateOverPushedOn];
        } else {
            [self setImageState:CTPushButtonImageStatePushedOn];
        }
    } else {
        if (self.mouseEntered) {
            [self setImageState:CTPushButtonImageStateOverPushedOff];
        } else {
            [self setImageState:CTPushButtonImageStatePushedOff];
        }
    }
}

- (void) setPushed:(BOOL)pushed {
    _pushed = pushed;
    [self _updateImageState];
}

- (void) setEnabled:(BOOL)enabled {
    _enabled = enabled;
    [self _updateImageState];
}

- (void) setMouseEntered:(BOOL)mouseEntered {
    _mouseEntered = mouseEntered;
    [self _updateImageState];
}

- (void) setMouseDown:(BOOL)mouseDown {
    _mouseDown = mouseDown;
    [self _updateImageState];
}

#pragma mark - Image setters

/* Choose the nearest possible image based on it availibility to "mirror" internal state of the button
 */
- (void) setImageState:(CTPushOnPushOffButtonImageState) imageState {
    if (_imageState == imageState) return;
    
    _imageState = imageState;
    
    NSImage *newImageToDraw = nil;
    
    if (self.pushed) {
        newImageToDraw = self.pushedOnImage;
    } else {
        newImageToDraw = self.pushedOffImage;
    }
    
    if (imageState == CTPushButtonImageStateOverPushedOn && self.overPushedOnImage != nil) {
        newImageToDraw = self.overPushedOnImage;
    }

    if (imageState == CTPushButtonImageStateOverPushedOff && self.overPushedOffImage != nil) {
        newImageToDraw = self.overPushedOffImage;
    }
    
    if (imageState == CTPushButtonImageStateClicked && self.clickedImage != nil) {
        newImageToDraw = self.clickedImage;
    }
    
    if (imageState == CTPushButtonImageStateDisabled && self.disabledImage != nil) {
        newImageToDraw = self.disabledImage;
    }
    
    [self setDrawnImage:newImageToDraw];
}

- (void) setDrawnImage:(NSImage *)drawnImage {
    if (_drawnImage != drawnImage) {
        _drawnImage = drawnImage;
        [self setNeedsDisplay:YES];
    }
}

- (void) setPushedOffImage: (NSImage *)image {
    NSImage *previousImage = _pushedOffImage;
    _pushedOffImage = image;
    if (self.drawnImage == previousImage) {
        self.drawnImage = image;
    }
}

- (void) setOverPushedOffImage: (NSImage *)image {
    NSImage *previousImage = _overPushedOffImage;
    _overPushedOffImage = image;
    if (self.drawnImage == previousImage) {
        self.drawnImage = image;
    }
}

- (void) setPushedOnImage: (NSImage *)image {
    NSImage *previousImage = _pushedOnImage;
    _pushedOnImage = image;
    if (self.drawnImage == previousImage) {
        self.drawnImage = image;
    }
}

- (void) setOverPushedOnImage: (NSImage *)image {
    NSImage *previousImage = _overPushedOnImage;
    _overPushedOnImage = image;
    if (self.drawnImage == previousImage) {
        self.drawnImage = image;
    }
}

- (void) setClickedImage: (NSImage *)image {
    NSImage *previousImage = _clickedImage;
    _clickedImage = image;
    if (self.drawnImage == previousImage) {
        self.drawnImage = image;
    }
}

- (void) setDisabledImage: (NSImage *)image {
    NSImage *previousImage = _disabledImage;
    _disabledImage = image;
    if (self.drawnImage == previousImage) {
        self.drawnImage = image;
    }
}

#pragma mark View methods

- (void)drawRect:(NSRect)dirtyRect
{
    [self.drawnImage drawInRect:self.bounds fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
}

- (void) updateTrackingAreas {
    [super updateTrackingAreas];
    if (self.trackingArea) {
        [self removeTrackingArea:self.trackingArea];
    }
    
    NSTrackingAreaOptions focusTrackingAreaOptions = NSTrackingActiveInActiveApp;
    focusTrackingAreaOptions |= NSTrackingMouseEnteredAndExited;
    focusTrackingAreaOptions |= NSTrackingEnabledDuringMouseDrag;
    self.trackingArea = [[NSTrackingArea alloc] initWithRect:self.bounds
                                                     options:focusTrackingAreaOptions owner:self userInfo:nil];
    [self addTrackingArea:self.trackingArea];
}

- (void)mouseDown:(NSEvent *)event {
    self.mouseDown = YES;
}

- (void) mouseUp:(NSEvent *)theEvent {
    self.mouseDown = NO;
    
    if (self.enabled && self.mouseEntered) {
        self.pushed = !self.pushed;
        [self.delegate buttonStateChanged:self];
    }
}

- (void) mouseEntered:(NSEvent *)theEvent {
    self.mouseEntered = YES;
}

- (void) mouseExited:(NSEvent *)theEvent {
    self.mouseEntered = NO;
}

@end
