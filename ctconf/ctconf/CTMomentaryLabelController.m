//
//  CTMomentaryLabelController.m
//  ctconf
//
//  Created by Dmitry Nikolaev on 04.09.12.
//  Copyright (c) 2012 cocotype.com. All rights reserved.
//

#import "CTMomentaryLabelController.h"
#import "CTRoundedLabelImageComposer.h"

@interface CTMomentaryLabelController ()

@property (strong, nonatomic) CTMomentaryButton *button;
@property (strong, nonatomic) CTRoundedLabelImageComposer *imageComposer;

@end

@implementation CTMomentaryLabelController

- (void) _recreateImages {
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
    [self.imageComposer setTextFont:textFont];
    [self _recreateImages];
}

- (void) setText:(NSString *)text {
    _text = [text copy];
    [self _recreateImages];
}

- (void) setRoundedCornerRadius:(CGFloat)roundedCornerRadius {
    _roundedCornerRadius = roundedCornerRadius;
    [self.imageComposer setRoundedCornerRadius:roundedCornerRadius];
    [self _recreateImages];
}

- (void) setVerticalPadding:(CGFloat)verticalPadding {
    _verticalPadding = verticalPadding;
    [self.imageComposer setVerticalPadding:verticalPadding];
    [self _recreateImages];
}

- (void) setHorizontalPadding:(CGFloat)horizontalPadding {
    _horizontalPadding = horizontalPadding;
    [self.imageComposer setHorizontalPadding:horizontalPadding];
    [self _recreateImages];
}




@end
