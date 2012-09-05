//
//  CTRoundedLabelImageComposer.h
//  ctconf
//
//  Created by Dmitry Nikolaev on 04.09.12.
//  Copyright (c) 2012 cocotype.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CTRoundedLabelImageComposer : NSObject

@property (copy, nonatomic) NSString *text;

@property (assign, nonatomic) CGFloat roundedCornerRadius;
@property (assign, nonatomic) CGFloat labelPadding;
@property (assign, nonatomic) CGFloat verticalPadding;
@property (assign, nonatomic) CGFloat horizontalPadding;
@property (copy, nonatomic) NSFont *textFont;
@property (copy, nonatomic) NSColor *labelColor;
@property (copy, nonatomic) NSColor *textColor;

@property (assign, nonatomic) CGFloat topEdgeTextRectCorrection;

- (NSImage *) composeImage;

@end
