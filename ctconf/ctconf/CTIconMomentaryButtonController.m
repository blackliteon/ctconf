//
//  CTIconMomentaryButtonController.m
//  ctconf
//
//  Created by Dmitry Nikolaev on 28.09.12.
//  Copyright (c) 2012 cocotype.com. All rights reserved.
//

#import "CTIconMomentaryButtonController.h"
#import "CTMomentaryButton.h"
#import <ctconf/ctconf.h>

@interface CTIconMomentaryButtonController ()

@property (strong, nonatomic, readwrite) CTMomentaryButton *button;

@property (strong, nonatomic) NSString *stylesPropertyName;
@property (strong, nonatomic) NSString *backgroundPropertyName;
@property (strong, nonatomic) NSString *templatePathProperty;

@property (copy, nonatomic) NSColor *backgroundColor;
@property (copy, nonatomic) NSString *templatePath;

// styles

@property (copy, nonatomic) NSColor *defaultColor;
@property (copy, nonatomic) NSColor *overColor;
@property (copy, nonatomic) NSColor *clickedColor;
@property (copy, nonatomic) NSColor *disabledColor;

@property (assign, nonatomic) CGFloat width;

@end

@implementation CTIconMomentaryButtonController

- (NSString *) _p: (NSString *) characteristic {
    return [NSString stringWithFormat:@"%@.%@", self.stylesPropertyName, characteristic];
}

- (id) initWithImageTemplatePathPropertyName: (NSString *) templatePathProperty defaultPath: (NSString *) defaultPath stylesPropertyName: (NSString *) stylesProperty backgroudColorProperty: (NSString *) backgroundProperty {
    self = [super init];
    if (self) {
        self.stylesPropertyName = stylesProperty;
        self.backgroundPropertyName = backgroundProperty;
        self.templatePathProperty = templatePathProperty;
        
        _templatePath = [[CTConfiguration sharedInstance] addResourcePathProperty:self.templatePathProperty toObject:self key:@"templatePath" defaultPath:defaultPath];
        
        if (self.backgroundPropertyName) {
            _backgroundColor = [[CTConfiguration sharedInstance] addColorProperty:self.backgroundPropertyName toObject:self key:@"backgroundColor" defaultValue:[NSColor whiteColor]];
        }
        
        _width = [[CTConfiguration sharedInstance] addDoubleProperty:[self _p:@"width"] toObject:self key:@"width" defaultValue:0];
        _defaultColor = [[CTConfiguration sharedInstance] addColorProperty:[self _p:@"defaultColor"] toObject:self key:@"defaultColor" defaultValue:[NSColor blackColor]];
        _overColor = [[CTConfiguration sharedInstance] addColorProperty:[self _p:@"overColor"] toObject:self key:@"overColor" defaultValue:[NSColor blackColor]];
        _clickedColor = [[CTConfiguration sharedInstance] addColorProperty:[self _p:@"clickedColor"] toObject:self key:@"clickedColor" defaultValue:[NSColor blackColor]];
        _disabledColor = [[CTConfiguration sharedInstance] addColorProperty:[self _p:@"disabledColor"] toObject:self key:@"disabledColor" defaultValue:[NSColor blackColor]];
        
        [self _recreateImages];
    }
    return self;
}

- (id) initWithImageTemplatePathPropertyName: (NSString *) templatePathProperty stylesPropertyName: (NSString *) stylesProperty backgroudColorProperty: (NSString *) backgroundProperty {
    return [self initWithImageTemplatePathPropertyName:templatePathProperty defaultPath:@"" stylesPropertyName:stylesProperty backgroudColorProperty:backgroundProperty];
}


- (id) initWithTemplatePathName: (NSString *) templatePathProperty defaultPath: (NSString *) defaultPath stylesName: (NSString *) stylesProperty {
    NSString *bgFullPropertyName = [NSString stringWithFormat:@"%@.%@", stylesProperty, @"backgroundColor"];
    return [self initWithImageTemplatePathPropertyName:templatePathProperty defaultPath:defaultPath stylesPropertyName:stylesProperty backgroudColorProperty:bgFullPropertyName];
}


- (void) dealloc {
    [[CTConfiguration sharedInstance] unregisterObjectFromUpdates:self];
}

- (void) _recreateImages {
    NSImage *image = [[NSImage alloc] initWithContentsOfFile:self.templatePath];
    
    if (self.width > 0) {
        NSSize size = image.size;
        float k = size.width / self.width;
        CGFloat height = size.height / k;
        [image setSize:NSMakeSize(self.width, height)];
    }
    
    [self.button setFrameSize:image.size];
    
    self.button.defaultImage = [image tintedImageWithColor:self.defaultColor];
    self.button.overDefaultImage = [image tintedImageWithColor:self.overColor];
    self.button.clickedImage = [image tintedImageWithColor:self.clickedColor];
    self.button.disabledImage = [image tintedImageWithColor:self.disabledColor];
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

- (void) setDefaultColor:(NSColor *)defaultColor {
    _defaultColor = [defaultColor copy];
    [self _recreateImages];
}

- (void) setOverColor:(NSColor *)overColor {
    _overColor = [overColor copy];
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

#pragma mark Initializers

- (CTMomentaryButton *) button {
    if (!_button) {
        _button = [[CTMomentaryButton alloc] initWithFrame:NSZeroRect];
    }
    return _button;
}


@end
