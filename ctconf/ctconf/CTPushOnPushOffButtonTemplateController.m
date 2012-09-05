//
//  CTPushOnPushOffButtonTemplateController.m
//  ctconf
//
//  Created by Dmitry Nikolaev on 05.09.12.
//  Copyright (c) 2012 cocotype.com. All rights reserved.
//

#import "CTPushOnPushOffButtonTemplateController.h"
#import "CTPushOnPushOffButton.h"
#import "CTRoundedLabelImageComposer.h"
#import "CTConfiguration.h"
#import "NSImage+Tint.h"

@interface CTPushOnPushOffButtonTemplateController ()

@property (strong, nonatomic) NSString *stylesPropertyName;
@property (strong, nonatomic) NSString *backgroundPropertyName;
@property (strong, nonatomic) NSString *templatePathProperty;
@property (strong, nonatomic) CTPushOnPushOffButton *button;

@property (strong, nonatomic) CTRoundedLabelImageComposer *imageComposer;

@property (copy, nonatomic) NSColor *backgroundColor;
@property (copy, nonatomic) NSString *templatePath;

// styles

@property (copy, nonatomic) NSColor *pushedOnColor;
@property (copy, nonatomic) NSColor *pushedOffColor;
@property (copy, nonatomic) NSColor *overPushedOnColor;
@property (copy, nonatomic) NSColor *overPushedOffColor;
@property (copy, nonatomic) NSColor *clickedColor;
@property (copy, nonatomic) NSColor *disabledColor;

@property (assign, nonatomic) CGFloat width;

@end

@implementation CTPushOnPushOffButtonTemplateController

- (NSString *) _p: (NSString *) characteristic {
    return [NSString stringWithFormat:@"%@.%@", self.stylesPropertyName, characteristic];
}

- (id) initWithImageTemplatePathPropertyName: (NSString *) templatePathProperty stylesPropertyName: (NSString *) stylesProperty backgroudColorProperty: (NSString *) backgroundProperty {
    self = [super init];
    
    if (self) {
        self.stylesPropertyName = stylesProperty;
        self.backgroundPropertyName = backgroundProperty;
        self.templatePathProperty = templatePathProperty;
        
        _templatePath = [[CTConfiguration sharedInstance] addResourcePathProperty:self.templatePathProperty toObject:self key:@"templatePath" defaultPath:@""];
        
        if (self.backgroundPropertyName) {
            _backgroundColor = [[CTConfiguration sharedInstance] addColorProperty:self.backgroundPropertyName toObject:self key:@"backgroundColor" defaultValue:[NSColor whiteColor]];
        }
        
        _width = [[CTConfiguration sharedInstance] addDoubleProperty:[self _p:@"width"] toObject:self key:@"width" defaultValue:0];
        _pushedOnColor = [[CTConfiguration sharedInstance] addColorProperty:[self _p:@"pushedOnColor"] toObject:self key:@"pushedOnColor" defaultValue:[NSColor blackColor]];
        _pushedOffColor = [[CTConfiguration sharedInstance] addColorProperty:[self _p:@"pushedOffColor"] toObject:self key:@"pushedOffColor" defaultValue:[NSColor blackColor]];
        _overPushedOnColor = [[CTConfiguration sharedInstance] addColorProperty:[self _p:@"overPushedOnColor"] toObject:self key:@"overPushedOnColor" defaultValue:[NSColor blackColor]];
        _overPushedOffColor = [[CTConfiguration sharedInstance] addColorProperty:[self _p:@"overPushedOffColor"] toObject:self key:@"overPushedOffColor" defaultValue:[NSColor blackColor]];
        _clickedColor = [[CTConfiguration sharedInstance] addColorProperty:[self _p:@"clickedColor"] toObject:self key:@"clickedColor" defaultValue:[NSColor blackColor]];
        _disabledColor = [[CTConfiguration sharedInstance] addColorProperty:[self _p:@"disabledColor"] toObject:self key:@"disabledColor" defaultValue:[NSColor blackColor]];
        
        [self _recreateImages];
    }
    
    return self;
}

- (void) _recreateImages {
    NSImage *image = [[NSImage alloc] initWithContentsOfFile:self.templatePath];
    
    // TODO: implement width processing
    
    [self.button setFrameSize:image.size];
    
    self.button.pushedOffImage = [image tintedImageWithColor:self.pushedOffColor];
    self.button.pushedOnImage = [image tintedImageWithColor:self.pushedOnColor];
    self.button.overPushedOnImage = [image tintedImageWithColor:self.overPushedOnColor];
    self.button.overPushedOffImage = [image tintedImageWithColor:self.overPushedOffColor];
    self.button.clickedImage = [image tintedImageWithColor:self.clickedColor];
    self.button.disabledImage = [image tintedImageWithColor:self.disabledColor];
    
}

#pragma mark - Initializers

- (CTPushOnPushOffButton *) button {
    if (!_button) {
        _button = [[CTPushOnPushOffButton alloc] initWithFrame:NSZeroRect];
    }
    return _button;
}

#pragma mark - Config setters

- (void) setWidth:(CGFloat)width {
    _width = width;
    [self _recreateImages];
}

- (void) setTemplatePath:(NSString *)templatePath {
    _templatePath = [templatePath copy];
    [self _recreateImages];
}

- (void) setBackgroundColor:(NSColor *)backgroundColor {
    _backgroundColor = [backgroundColor copy];
    [self _recreateImages];
}

- (void) setPushedOffColor:(NSColor *)pushedOffColor {
    _pushedOffColor = [pushedOffColor copy];
    [self _recreateImages];
}

- (void) setPushedOnColor:(NSColor *)pushedOnColor {
    _pushedOnColor = [pushedOnColor copy];
    [self _recreateImages];
}

- (void) setOverPushedOffColor:(NSColor *)overPushedOffColor {
    _overPushedOffColor = [overPushedOffColor copy];
    [self _recreateImages];
}

- (void) setOverPushedOnColor:(NSColor *)overPushedOnColor {
    _overPushedOnColor = [overPushedOnColor copy];
    [self _recreateImages];
}

- (void) setClickedColor:(NSColor *)clickedColor {
    _clickedColor = [clickedColor copy];
    [self _recreateImages];
}

- (void) setDisabledColor:(NSColor *)disabledColor {
    _disabledColor = [disabledColor copy];
    [self _recreateImages];
}


@end
