//
//  CTRectProperty.m
//  ctconf
//
//  Created by Dmitry Nikolaev on 16.01.13.
//  Copyright (c) 2013 cocotype.com. All rights reserved.
//

#import "CTRectProperty.h"
#import "NSString+CTAdditions.h"
#import "NSArray+CTAdditions.h"

@implementation CTRectProperty

- (BOOL) isValueEqualTo: (id) newValue {
    NSValue *normalizedCurrent = _value ? _value : self.defaultValue;
    NSValue *normalizedNew = newValue ? newValue : self.defaultValue;
    
    if (normalizedCurrent == normalizedNew) return YES;
    if (normalizedCurrent == nil || normalizedNew == nil) return NO;
    return [normalizedCurrent isEqualToValue:normalizedNew];
}

- (NSString *) toString {
    NSRect rect = [self.value rectValue];
    NSArray *elements = [NSArray arrayWithObjects:[NSNumber numberWithDouble:rect.origin.x], [NSNumber numberWithDouble:rect.origin.y],[NSNumber numberWithDouble:rect.size.width],[NSNumber numberWithDouble:rect.size.height],nil];
    return [elements stringWithParenthesesFromNumberArray];
}

- (void) fromString: (NSString *) stringValue {
    NSArray *elements = [stringValue arrayWithDoublesFromStringWithParentheses];
    NSNumber *x = [elements objectAtIndex:0];
    NSNumber *y = [elements objectAtIndex:1];
    NSNumber *width = [elements objectAtIndex:2];
    NSNumber *height = [elements objectAtIndex:3];
    NSRect rect = NSMakeRect(x.doubleValue, y.doubleValue, width.doubleValue, height.doubleValue);
    self.value = [NSValue valueWithRect:rect];
}

@end
