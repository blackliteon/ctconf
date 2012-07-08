//
//  BGView.m
//  demoapp
//
//  Created by Dmitry Nikolaev on 08.07.12.
//  Copyright (c) 2012 cocotype.com. All rights reserved.
//

#import "BGView.h"

@implementation BGView

@synthesize bgColor = _bgColor;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    
    return self;
}

- (void) setBgColor:(NSColor *)bgColor {
    _bgColor = [bgColor copy];
    [self setNeedsDisplay:YES];
}

- (void)drawRect:(NSRect)dirtyRect
{
    [self.bgColor setFill];
    NSRectFill(dirtyRect);
}

@end
