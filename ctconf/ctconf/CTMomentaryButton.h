//
//  CTButton.h
//  ctconf
//
//  Created by Dmitry Nikolaev on 15.07.12.
//  Copyright (c) 2012 cocotype.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class CTMomentaryButton;

@protocol CTMomentaryButtonDelegate <NSObject>

- (void) buttonClicked: (CTMomentaryButton *) button;

@optional

- (void) buttonDragged: (CTMomentaryButton *) button event: (NSEvent *) theEvent;

@end


@interface CTMomentaryButton : NSView

- (id)initWithFrame:(NSRect)frame;

- (void) setImagesFromPath: (NSString *) path sizeFromImageData: (BOOL) sizeFromImage;
@property (copy, nonatomic) NSString *identifier;
@property (assign, nonatomic) BOOL enabled;
@property (assign, nonatomic) id<CTMomentaryButtonDelegate> delegate;

@property (unsafe_unretained, nonatomic) id target;
@property (assign, nonatomic) SEL action;

// images

@property (strong, nonatomic) NSImage *defaultImage;
@property (strong, nonatomic) NSImage *overDefaultImage;
@property (strong, nonatomic) NSImage *clickedImage;
@property (strong, nonatomic) NSImage *disabledImage;


@end
