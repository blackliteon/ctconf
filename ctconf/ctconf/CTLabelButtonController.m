//
//  CTMomentaryLabelController.m
//  ctconf
//
//  Created by Dmitry Nikolaev on 04.09.12.
//  Copyright (c) 2012 cocotype.com. All rights reserved.
//

#import "CTLabelButtonController.h"
#import "CTRoundedLabelImageComposer.h"
#import "CTMomentaryButton.h"
#import "CTConfiguration.h"

@interface CTLabelButtonController ()

@property (strong, nonatomic) CTMomentaryButton *button;
@property (strong, nonatomic) CTRoundedLabelImageComposer *imageComposer;
@property (strong, nonatomic) NSString *propertyName;

@property (assign, nonatomic) CGFloat verticalPadding;
@property (assign, nonatomic) CGFloat horizontalPadding;
@property (copy, nonatomic) NSFont *textFont;
@property (assign, nonatomic) CGFloat roundedCornerRadius;
@property (assign, nonatomic) CGFloat topEdgeTextRectCorrection;

@property (copy, nonatomic) NSColor *defaultTextColor;
@property (copy, nonatomic) NSColor *defaultLabelColor;
@property (copy, nonatomic) NSColor *overTextColor;
@property (copy, nonatomic) NSColor *overLabelColor;
@property (copy, nonatomic) NSColor *clickedTextColor;
@property (copy, nonatomic) NSColor *clickedLabelColor;
@property (copy, nonatomic) NSColor *disabledTextColor;
@property (copy, nonatomic) NSColor *disabledLabelColor;

@end

@implementation CTLabelButtonController

- (NSString *) _p: (NSString *) characteristic {
    return [NSString stringWithFormat:@"%@.%@", self.propertyName, characteristic];
}

- (id) initWithPropertyName: (NSString *) name text: (NSString *) text {
    self = [super init];
    if (self) {
        self.propertyName = name;
        
        _text = [text copy];
        
        _verticalPadding = [[CTConfiguration sharedInstance] addDoubleProperty:[self _p:@"verticalPadding"] toObject:self key:@"verticalPadding" defaultValue:4];
        _horizontalPadding = [[CTConfiguration sharedInstance] addDoubleProperty:[self _p:@"horizontalPadding"] toObject:self key:@"horizontalPadding" defaultValue:4];
        _textFont = [[CTConfiguration sharedInstance] addFontProperty:[self _p:@"textFont"] toObject:self key:@"textFont" defaultValue:[NSFont fontWithName:@"Helvetica" size:12]];
        _roundedCornerRadius = [[CTConfiguration sharedInstance] addDoubleProperty:[self _p:@"roundedCornerRadius"] toObject:self key:@"roundedCornerRadius" defaultValue:2];
        _topEdgeTextRectCorrection = [[CTConfiguration sharedInstance] addDoubleProperty:[self _p:@"topEdgeTextRectCorrection"] toObject:self key:@"topEdgeTextRectCorrection" defaultValue:0];

        _defaultTextColor = [[CTConfiguration sharedInstance] addColorProperty:[self _p:@"defaultTextColor"] toObject:self key:@"defaultTextColor" defaultValue:[NSColor whiteColor]];
        _defaultLabelColor = [[CTConfiguration sharedInstance] addColorProperty:[self _p:@"defaultLabelColor"] toObject:self key:@"defaultLabelColor" defaultValue:[NSColor blackColor]];
        _overTextColor = [[CTConfiguration sharedInstance] addColorProperty:[self _p:@"overTextColor"] toObject:self key:@"overTextColor" defaultValue:[NSColor whiteColor]];
        _overLabelColor = [[CTConfiguration sharedInstance] addColorProperty:[self _p:@"overLabelColor"] toObject:self key:@"overLabelColor" defaultValue:[NSColor blackColor]];
        _clickedTextColor = [[CTConfiguration sharedInstance] addColorProperty:[self _p:@"clickedTextColor"] toObject:self key:@"clickedTextColor" defaultValue:[NSColor whiteColor]];
        _clickedLabelColor = [[CTConfiguration sharedInstance] addColorProperty:[self _p:@"clickedLabelColor"] toObject:self key:@"clickedLabelColor" defaultValue:[NSColor redColor]];
        _disabledTextColor = [[CTConfiguration sharedInstance] addColorProperty:[self _p:@"disabledTextColor"] toObject:self key:@"disabledTextColor" defaultValue:[NSColor whiteColor]];
        _disabledLabelColor = [[CTConfiguration sharedInstance] addColorProperty:[self _p:@"disabledLabelColor"] toObject:self key:@"disabledLabelColor" defaultValue:[NSColor blackColor]];
        
        [self _recreateImages];
    }
    return self;
}

- (void) dealloc {
    [[CTConfiguration sharedInstance] unregisterObjectFromUpdates:self];
}

- (void) _recreateImages {
    [self.imageComposer setText:self.text];
    
    [self.imageComposer setTextFont:self.textFont];
    [self.imageComposer setRoundedCornerRadius:self.roundedCornerRadius];
    [self.imageComposer setVerticalPadding:self.verticalPadding];
    [self.imageComposer setHorizontalPadding:self.horizontalPadding];
    
    [self.imageComposer setTopEdgeTextRectCorrection:self.topEdgeTextRectCorrection];
    
    [self.imageComposer setTextColor:self.defaultTextColor];
    [self.imageComposer setLabelColor:self.defaultLabelColor];
    
    NSImage *defaultImage = [self.imageComposer composeImage];
    [self.button setFrameSize:defaultImage.size];
    [self.button setDefaultImage:defaultImage];

    [self.imageComposer setTextColor:self.overTextColor];
    [self.imageComposer setLabelColor:self.overLabelColor];
    [self.button setOverDefaultImage:[self.imageComposer composeImage]];

    [self.imageComposer setTextColor:self.clickedTextColor];
    [self.imageComposer setLabelColor:self.clickedLabelColor];
    [self.button setClickedImage:[self.imageComposer composeImage]];

    [self.imageComposer setTextColor:self.disabledTextColor];
    [self.imageComposer setLabelColor:self.disabledLabelColor];
    [self.button setDisabledImage:[self.imageComposer composeImage]];
}


- (CTMomentaryButton *) button {
    if (!_button) {
        _button = [[CTMomentaryButton alloc] initWithFrame:NSZeroRect];
    }
    return _button;
}

- (CTRoundedLabelImageComposer *) imageComposer {
    if (!_imageComposer) {
        _imageComposer = [[CTRoundedLabelImageComposer alloc] init];
    }
    return _imageComposer;
}

#pragma mark Properties

- (void) setTextFont:(NSFont *)textFont {
    _textFont = [textFont copy];
    [self _recreateImages];
}

- (void) setText:(NSString *)text {
    _text = [text copy];
    [self _recreateImages];
}

- (void) setRoundedCornerRadius:(CGFloat)roundedCornerRadius {
    _roundedCornerRadius = roundedCornerRadius;
    [self _recreateImages];
}

- (void) setVerticalPadding:(CGFloat)verticalPadding {
    _verticalPadding = verticalPadding;
    [self _recreateImages];
}

- (void) setHorizontalPadding:(CGFloat)horizontalPadding {
    _horizontalPadding = horizontalPadding;
    [self _recreateImages];
}

- (void) setTopEdgeTextRectCorrection:(CGFloat)topEdgeTextRectCorrection {
    _topEdgeTextRectCorrection = topEdgeTextRectCorrection;
    [self _recreateImages];
}

// colors

- (void) setDefaultTextColor:(NSColor *)defaultTextColor {
    _defaultTextColor = [defaultTextColor copy];
    [self _recreateImages];
}

- (void) setDefaultLabelColor:(NSColor *)defaultLabelColor {
    _defaultLabelColor = [defaultLabelColor copy];
    [self _recreateImages];
}

- (void) setOverTextColor:(NSColor *)overTextColor {
    _overTextColor = [overTextColor copy];
    [self _recreateImages];
}

- (void) setOverLabelColor:(NSColor *)overLabelColor {
    _overLabelColor = [overLabelColor copy];
    [self _recreateImages];
}

- (void) setClickedTextColor:(NSColor *)clickedTextColor {
    _clickedTextColor = [clickedTextColor copy];
    [self _recreateImages];
}

- (void) setClickedLabelColor:(NSColor *)clickedLabelColor {
    _clickedLabelColor = [clickedLabelColor copy];
    [self _recreateImages];
}

- (void) setDisabledTextColor:(NSColor *)disabledTextColor {
    _disabledTextColor = [disabledTextColor copy];
    [self _recreateImages];
}

- (void) setDisabledLabelColor:(NSColor *)disabledLabelColor {
    _disabledLabelColor = [disabledLabelColor copy];
    [self _recreateImages];
}




@end
