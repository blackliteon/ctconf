//
//  AHorizontalContainerViewController.m
//  Writebox
//
//  Created by Dmitry Nikolaev on 17.09.12.
//  Copyright (c) 2012 Apprium. All rights reserved.
//

#import "CTHorizontalContainerViewController.h"
#import "CTHorizontalContainerView.h"
#import <ctconf/ctconf.h>

@interface CTHorizontalContainerViewController ()

@property (strong, nonatomic, readwrite) CTHorizontalContainerView *containerView;
@property (copy, nonatomic) NSString *propertyName;

// configuration properties

@property (copy, nonatomic) NSColor *backgroundColor;
@property (assign, nonatomic) CGFloat iconSpace;
@property (assign, nonatomic) BOOL highlighted;
@property (copy, nonatomic) CTHorizontalContainerItemsAlignment alignment;
@property (assign, nonatomic) CGFloat leftMargin;
@property (assign, nonatomic) CGFloat horizontalCorrection;
@property (assign, nonatomic) CGFloat leftItemsSpacing;
@property (assign, nonatomic) BOOL alignmentConsiderSideItems;

@end


@implementation CTHorizontalContainerViewController

- (NSString *) _p: (NSString *) characteristic {
    return [NSString stringWithFormat:@"%@.%@", self.propertyName, characteristic];
}

- (id) initWithPropertyName: (NSString *) propertyName {
    self = [super init];
    if (self) {
        self.propertyName = propertyName;
        
        self.backgroundColor = [[CTConfiguration sharedInstance] addColorProperty:[self _p:@"backgroundColor"] toObject:self key:@"backgroundColor" defaultValue:[NSColor whiteColor]];
        
        self.iconSpace = [[CTConfiguration sharedInstance] addDoubleProperty:[self _p:@"iconSpace"] toObject:self key:@"iconSpace" defaultValue:4];
        
        self.highlighted = [[CTConfiguration sharedInstance] addBooleanProperty:[self _p:@"highlighted"] toObject:self key:@"highlighted" defaultValue:NO];
        
        self.alignment = [[CTConfiguration sharedInstance] addEnumerateProperty:[self _p:@"alignment"] toObject:self key:@"alignment" defaultValue:CTHorizontalContainerCenterAlignment possibleValues:CTHorizontalContainerCenterAlignment, CTHorizontalContainerLeftAlignment, nil];
        
        self.leftMargin = [[CTConfiguration sharedInstance] addDoubleProperty:[self _p:@"leftMargin"] toObject:self key:@"leftMargin" defaultValue:0];
        self.horizontalCorrection = [[CTConfiguration sharedInstance] addDoubleProperty:[self _p:@"horizontalCorrection"] toObject:self key:@"horizontalCorrection" defaultValue:0];

        self.leftItemsSpacing = [[CTConfiguration sharedInstance] addDoubleProperty:[self _p:@"leftItemsSpacing"] toObject:self key:@"leftItemsSpacing" defaultValue:20];
        self.alignmentConsiderSideItems = [[CTConfiguration sharedInstance] addBooleanProperty:[self _p:@"alignmentConsiderSideItems"] toObject:self key:@"alignmentConsiderSideItems" defaultValue:NO];
        
    }
    return self;
}

- (void)dealloc {
    [[CTConfiguration sharedInstance] unregisterObjectFromUpdates:self];
}

- (void) setBackgroundColor:(NSColor *)backgroundColor {
    _backgroundColor = [backgroundColor copy];
    self.containerView.backgroundColor = self.backgroundColor;
}

- (void) setIconSpace: (CGFloat) iconSpace {
    _iconSpace = iconSpace;
    [self.containerView setItemsSpace:iconSpace];
}

- (void) setHighlighted:(BOOL)highlighted {
    _highlighted = highlighted;
    [self.containerView setHighlight:highlighted];
}

- (void) setAlignment:(CTHorizontalContainerItemsAlignment)alignment {
    _alignment = [alignment copy];
    [self.containerView setAlignment:alignment];
}

- (void) setLeftMargin:(CGFloat)leftMargin {
    _leftMargin = leftMargin;
    [self.containerView setLeftMargin:leftMargin];
}

- (void) setHorizontalCorrection:(CGFloat)horizontalCorrection {
    _horizontalCorrection = horizontalCorrection;
    [self.containerView setHorizontalCorrection:horizontalCorrection];
}

- (void) setLeftItemsSpacing:(CGFloat)leftItemsSpacing {
    _leftItemsSpacing = leftItemsSpacing;
    [self.containerView setLeftItemsSpacing:leftItemsSpacing];
}

- (void) setAlignmentConsiderSideItems:(BOOL)alignmentConsiderSideItems {
    _alignmentConsiderSideItems = alignmentConsiderSideItems;
    [self.containerView setCenterAlignmentConsiderSideItems:alignmentConsiderSideItems];
}

#pragma mark - Initializers

- (CTHorizontalContainerView *) containerView {
    if (!_containerView) {
        _containerView = [[CTHorizontalContainerView alloc] initWithFrame:NSZeroRect];
    }
    return _containerView;
}

@end
