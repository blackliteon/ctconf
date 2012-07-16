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

- (void) buttonDragged: (CTMomentaryButton *) button;

@end


@interface CTMomentaryButton : NSView

- (id)initWithFrame:(NSRect)frame;
- (void) setImagesFromPath: (NSString *) path;
@property (copy, nonatomic) NSString *identifier;
@property (assign, nonatomic) BOOL enabled;
@property (assign, nonatomic) id<CTMomentaryButtonDelegate> delegate;

@end
