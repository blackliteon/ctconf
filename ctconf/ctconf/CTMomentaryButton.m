//
//  CTButton.m
//  ctconf
//
//  Created by Dmitry Nikolaev on 15.07.12.
//  Copyright (c) 2012 cocotype.com. All rights reserved.
//

#import "CTMomentaryButton.h"

enum {
    CTButtonImageStateDefault,
    CTButtonImageStateOverDefault,
    CTButtonImageStateClicked,
    CTButtonImageStateDisabled
    };

typedef NSUInteger CTMomentaryButtonImageState;

@interface CTMomentaryButton ()

@property (strong, nonatomic) NSImage *defaultImage;
@property (strong, nonatomic) NSImage *overDefaultImage;
@property (strong, nonatomic) NSImage *clickedImage;
@property (strong, nonatomic) NSImage *disabledImage;

@property (assign, nonatomic) BOOL mouseEntered;
@property (assign, nonatomic) BOOL mouseDown;

@property (assign, nonatomic) CTMomentaryButtonImageState imageState;
@property (strong, nonatomic) NSImage *drawnImage; // do not update this value for state update, use imageState
@property (strong, nonatomic) NSTrackingArea *trackingArea;

@end

@implementation CTMomentaryButton

@synthesize identifier = _identifier;
@synthesize enabled = _enabled;
@synthesize delegate = _delegate;

@synthesize defaultImage = _defaultImage;
@synthesize overDefaultImage = _overDefaultImage;
@synthesize clickedImage = _clickedImage;
@synthesize disabledImage = _disabledImage;

@synthesize mouseEntered = _mouseEntered;
@synthesize mouseDown = _mouseDown;

@synthesize imageState = _imageState;
@synthesize drawnImage = _drawnImage;
@synthesize trackingArea = _trackingArea;

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.enabled = YES;
        self.mouseEntered = NO;
    }
    
    return self;
}

- (void) setImagesFromPath: (NSString *) path sizeFromImageData: (BOOL) sizeFromImage {
    self.defaultImage = [[NSImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@.png", path]];
    self.overDefaultImage = [[NSImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@_over.png", path]];
    self.clickedImage = [[NSImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@_clicked.png", path]];
    self.disabledImage = [[NSImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@_disabled.png", path]];
    
    if (sizeFromImage) {
        [self setFrameSize:self.defaultImage.size];
    }
}

#pragma mark - State setters

- (void) _updateImageState {
    
    if (!self.enabled) {
        [self setImageState:CTButtonImageStateDisabled];
        return;
    }
    
    if (self.mouseEntered) {
        if (self.mouseDown) {
            [self setImageState:CTButtonImageStateClicked];
        } else {
            [self setImageState:CTButtonImageStateOverDefault];
        }
    } else {
        if (self.mouseDown) {
            [self setImageState:CTButtonImageStateDefault];
        } else {
            [self setImageState:CTButtonImageStateDefault];
        }
    }
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

- (void) setImageState:(CTMomentaryButtonImageState) imageState {
    if (_imageState == imageState) return;

    _imageState = imageState;
    
    NSImage *newImageToDraw = self.defaultImage;
    
    if (imageState == CTButtonImageStateDisabled && self.disabledImage != nil) {
        newImageToDraw = self.disabledImage;
    }
    
    if (imageState == CTButtonImageStateOverDefault && self.overDefaultImage != nil) {
        newImageToDraw = self.overDefaultImage;
    }
    
    if (imageState == CTButtonImageStateClicked && self.clickedImage != nil) {
        newImageToDraw = self.clickedImage;
    }
    
    [self setDrawnImage:newImageToDraw];
}

- (void) setDrawnImage:(NSImage *)drawnImage {
    if (_drawnImage != drawnImage) {
        _drawnImage = drawnImage;
        [self setNeedsDisplay:YES];
    }
}

- (void) setDefaultImage: (NSImage *)image {
    NSImage *previousImage = _defaultImage;
    _defaultImage = image;
    if (self.drawnImage == previousImage) {
        self.drawnImage = image;
    }
}

- (void) setOverDefaultImage: (NSImage *)image {
    NSImage *previousImage = _overDefaultImage;
    _overDefaultImage = image;
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

- (BOOL)mouseDownCanMoveWindow {
    return NO;
}

#pragma mark - Mouse events

- (void)mouseDown:(NSEvent *)event {
    self.mouseDown = YES;
}

- (void) mouseUp:(NSEvent *)theEvent {
    self.mouseDown = NO;

    if (self.enabled && self.mouseEntered) {
        [self.delegate buttonClicked:self];
    }
}

- (void) mouseEntered:(NSEvent *)theEvent {
    self.mouseEntered = YES;
}

- (void) mouseExited:(NSEvent *)theEvent {
    self.mouseEntered = NO;
}

- (void) mouseDragged:(NSEvent *)theEvent {
    if ([self.delegate respondsToSelector:@selector(buttonDragged:event:)]) {
        [self.delegate buttonDragged:self event:theEvent];
    }
}

@end
