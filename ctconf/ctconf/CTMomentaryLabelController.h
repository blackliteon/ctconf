//
//  CTMomentaryLabelController.h
//  ctconf
//
//  Created by Dmitry Nikolaev on 04.09.12.
//  Copyright (c) 2012 cocotype.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CTMomentaryButton.h"

@interface CTMomentaryLabelController : NSObject

@property (copy, nonatomic) NSColor *defaultTextColor;
@property (copy, nonatomic) NSColor *defaultLabelColor;

@property (copy, nonatomic) NSColor *overTextColor;
@property (copy, nonatomic) NSColor *overLabelColor;

@property (copy, nonatomic) NSColor *clickedTextColor;
@property (copy, nonatomic) NSColor *clickedLabelColor;

@property (copy, nonatomic) NSColor *disabledTextColor;
@property (copy, nonatomic) NSColor *disabledLabelColor;

@property (assign, nonatomic) CGFloat verticalPadding;
@property (assign, nonatomic) CGFloat horizontalPadding;
@property (copy, nonatomic) NSFont *textFont;
@property (assign, nonatomic) CGFloat roundedCornerRadius;
@property (copy, nonatomic) NSString *text;

@property (strong, readonly, nonatomic) CTMomentaryButton *button;

@end
