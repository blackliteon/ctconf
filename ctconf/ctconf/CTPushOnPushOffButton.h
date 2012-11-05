//
//  CTPushOnPushOffButton.h
//  ctconf
//
//  Created by Dmitry Nikolaev on 16.07.12.
//  Copyright (c) 2012 cocotype.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class CTPushOnPushOffButton;

@protocol CTPushOnPushOffButtonDelegate <NSObject>

- (void) buttonStateChanged: (CTPushOnPushOffButton *) button;

@optional

- (BOOL) buttonWillChangeState: (CTPushOnPushOffButton *) button;

@end

@interface CTPushOnPushOffButton : NSView

- (id)initWithFrame:(NSRect)frame;
- (void) setImagesFromPath: (NSString *) path;
@property (copy, nonatomic) NSString *identifier;
@property (assign, nonatomic) BOOL enabled;
@property (assign, nonatomic) id<CTPushOnPushOffButtonDelegate> delegate;
@property (assign, nonatomic) BOOL pushed;

// images

@property (strong, nonatomic) NSImage *pushedOffImage;
@property (strong, nonatomic) NSImage *overPushedOffImage;
@property (strong, nonatomic) NSImage *pushedOnImage;
@property (strong, nonatomic) NSImage *overPushedOnImage;
@property (strong, nonatomic) NSImage *clickedImage;
@property (strong, nonatomic) NSImage *disabledImage;

@end
