//
//  CTConfigurableMomentaryButton.m
//  ctconf
//
//  Created by Dmitry Nikolaev on 15.01.13.
//  Copyright (c) 2013 cocotype.com. All rights reserved.
//

#import "CTConfigurableMomentaryButton.h"


@interface CTConfigurableMomentaryButton ()

@property (strong, nonatomic) NSString *stylesName;

// styles

@property (strong, nonatomic) CTButtonStyle *buttonStyle;

@end


@implementation CTConfigurableMomentaryButton

- (NSString *) _p: (NSString *) characteristic {
    return [NSString stringWithFormat:@"%@.%@", self.stylesName, characteristic];
}

- (id) initWithFrame:(NSRect)frame styleName: (NSString *) styleName defaultPath: (NSString *) path {
    self = [super initWithFrame:frame];
    if (self) {
        self.stylesName = styleName;
        
        CTButtonStyle *defaultStyle = [[CTButtonStyle alloc] init];
        defaultStyle.path = path;
        defaultStyle.tintBackground = [NSColor whiteColor];
        defaultStyle.color = [NSColor blackColor];
        defaultStyle.colorClicked = [NSColor blueColor];
        defaultStyle.colorOver = [NSColor blackColor];
        defaultStyle.colorDisabled = [NSColor grayColor];
        
        self.buttonStyle = confButtonStyle(styleName, self, @"buttonStyle", defaultStyle);

        [self _recreateImages];
    }
    return self;
}

- (void) setButtonStyle:(CTButtonStyle *)buttonStyle {
    _buttonStyle = buttonStyle;
    [self _recreateImages];
}

- (void) _recreateImages {
    NSImage *image = [[NSImage alloc] initWithContentsOfFile:self.buttonStyle.path];
    NSLog(@"recreate images with contents of file: %@", self.buttonStyle.path);
    
    self.defaultImage = [image tintedImageWithColor:self.buttonStyle.color];
    self.overDefaultImage = [image tintedImageWithColor:self.buttonStyle.colorOver];
    self.clickedImage = [image tintedImageWithColor:self.buttonStyle.colorClicked];
    self.disabledImage = [image tintedImageWithColor:self.buttonStyle.colorDisabled];
}

@end
