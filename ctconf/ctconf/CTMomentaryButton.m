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

@property (assign, nonatomic) CTMomentaryButtonImageState imageState;
@property (strong, nonatomic) NSImage *drawnImage; // do not update this value for state update, use imageState
@property (strong, nonatomic) NSTrackingArea *trackingArea;

@end

@implementation CTMomentaryButton

@synthesize identifier = _identifier;
@synthesize enabled = _enabled;

@synthesize defaultImage = _defaultImage;
@synthesize overDefaultImage = _overDefaultImage;
@synthesize clickedImage = _clickedImage;
@synthesize disabledImage = _disabledImage;

@synthesize imageState = _imageState;
@synthesize drawnImage = _drawnImage;
@synthesize trackingArea = _trackingArea;

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.enabled = YES;
    }
    
    return self;
}

- (void) updateTrackingAreas {
    [super updateTrackingAreas];
    NSLog(@"updateTrackingAreas");
    if (self.trackingArea) {
        [self removeTrackingArea:self.trackingArea];
    }
    
    NSTrackingAreaOptions focusTrackingAreaOptions = NSTrackingActiveInActiveApp;
    focusTrackingAreaOptions |= NSTrackingMouseEnteredAndExited;
    self.trackingArea = [[NSTrackingArea alloc] initWithRect:self.bounds
                                                     options:focusTrackingAreaOptions owner:self userInfo:nil];
    [self addTrackingArea:self.trackingArea];
}

- (void) setImagesFromPath: (NSString *) path {
    self.defaultImage = [[NSImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@.png", path]];
    self.overDefaultImage = [[NSImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@_over.png", path]];
    self.clickedImage = [[NSImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@_clicked.png", path]];
    self.disabledImage = [[NSImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@_disabled.png", path]];
    [self setNeedsDisplay:YES];
}

- (void) setEnabled:(BOOL)enabled {
    _enabled = enabled;
    self.imageState = _enabled ? CTButtonImageStateDefault : CTButtonImageStateDisabled;
}

- (void) setImageState:(CTMomentaryButtonImageState) imageState {

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

- (void)drawRect:(NSRect)dirtyRect
{
    [self.drawnImage drawInRect:self.bounds fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
}

#pragma mark - Mouse events

- (void)mouseDown:(NSEvent *)event {
    if (!self.enabled) return;
    [self setImageState:CTButtonImageStateClicked];
}

- (void) mouseUp:(NSEvent *)theEvent {
    [self setImageState:CTButtonImageStateDefault];
}

- (void) mouseEntered:(NSEvent *)theEvent {
    [self setImageState:CTButtonImageStateOverDefault];
}

- (void) mouseExited:(NSEvent *)theEvent {
    [self setImageState:CTButtonImageStateDefault];
}

- (void) mouseDragged:(NSEvent *)theEvent {
}
@end
