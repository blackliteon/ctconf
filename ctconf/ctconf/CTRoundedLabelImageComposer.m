//
//  CTRoundedLabelImageComposer.m
//  ctconf
//
//  Created by Dmitry Nikolaev on 04.09.12.
//  Copyright (c) 2012 cocotype.com. All rights reserved.
//

#import "CTRoundedLabelImageComposer.h"

@implementation CTRoundedLabelImageComposer

- (id)init
{
    self = [super init];
    if (self) {
        _roundedCornerRadius = 5;
        _labelPadding = 0;
        _verticalPadding = 4;
        _horizontalPadding = 6;
        _textFont = [NSFont fontWithName:@"Helvetica" size:18];
        _labelColor = [NSColor redColor];
        _textColor = [NSColor whiteColor];
    }
    
    return self;
}

- (NSImage *) composeImage {
    
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
    [attributes setObject:self.textFont forKey:NSFontAttributeName];
    [attributes setObject:self.textColor forKey:NSForegroundColorAttributeName];
    
    NSMutableParagraphStyle *parStyle = [[NSMutableParagraphStyle alloc] init];
    [parStyle setParagraphStyle:[NSParagraphStyle defaultParagraphStyle]];
    [parStyle setLineBreakMode:NSLineBreakByCharWrapping];
    [attributes setObject:parStyle forKey:NSParagraphStyleAttributeName];
    
    NSSize sizeWithFont = [self.text sizeWithAttributes:attributes];
    
    CGFloat imageWidth = sizeWithFont.width + self.horizontalPadding * 2 + self.labelPadding * 2;
    CGFloat imageHeight = sizeWithFont.height + self.verticalPadding * 2 + self.labelPadding * 2;
    
    NSImage* anImage = [[NSImage alloc] initWithSize:NSMakeSize(imageWidth,  imageHeight)];
    [anImage lockFocus];
    
    // Drawing here
    
    NSRect paddedRect = NSMakeRect(0, 0, imageWidth, imageHeight);
    paddedRect.origin.x += self.labelPadding;
    paddedRect.origin.y += self.labelPadding;
    paddedRect.size.width -= self.labelPadding * 2;
    paddedRect.size.height -= self.labelPadding * 2;
    
    paddedRect.size.height += self.topEdgeTextRectCorrection;
    
    NSBezierPath* mainPathWithRoundedCorners = [NSBezierPath bezierPath];
    [mainPathWithRoundedCorners appendBezierPathWithRoundedRect:paddedRect xRadius:self.roundedCornerRadius yRadius:self.roundedCornerRadius];
    
    [self.labelColor setFill];
    [mainPathWithRoundedCorners fill];
    
    // text
    
    CGFloat textRectHeight = sizeWithFont.height;
    CGFloat textRectWidth = sizeWithFont.width;
    CGFloat textRectY = imageHeight - self.verticalPadding - self.labelPadding - textRectHeight;
    CGFloat textRectX = self.horizontalPadding + self.labelPadding;
    
    NSRect textRect = NSMakeRect(textRectX, textRectY, textRectWidth, textRectHeight);

//  test text rect
//    [[NSColor blueColor] setFill];
//    NSRectFill(textRect);
    
    [self.text drawWithRect:textRect options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine attributes:attributes];
    
    [anImage unlockFocus];
    
    return anImage;
}

#pragma mark - Visual Properties

- (void) setText:(NSString *)text {
    _text = [text copy];
}

- (void) setRoundedCornerRadius:(CGFloat)roundedCornerRadius {
    _roundedCornerRadius = roundedCornerRadius;
}

- (void) setLabelPadding:(CGFloat)padding {
    _labelPadding = padding;
}

- (void) setVerticalPadding:(CGFloat)verticalTextPadding {
    _verticalPadding = verticalTextPadding;
}

- (void) setHorizontalPadding:(CGFloat)horizontalTextPadding {
    _horizontalPadding = horizontalTextPadding;
}

- (void) setTextFont:(NSFont *)textFont {
    _textFont = [textFont copy];
}

- (void) setLabelColor:(NSColor *)labelColor {
    _labelColor = [labelColor copy];
}

- (void) setTextColor:(NSColor *)textColor {
    _textColor = [textColor copy];
}


@end
