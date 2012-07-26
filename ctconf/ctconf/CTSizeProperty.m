//
//  CTSizeProperty.m
//  ctconf
//
//  Created by Dmitry Nikolaev on 12.07.12.
//  Copyright (c) 2012 cocotype.com. All rights reserved.
//

#import "CTSizeProperty.h"
#import "NSString+CTAdditions.h"
#import "NSArray+CTAdditions.h"

@implementation CTSizeProperty

#pragma mark - Property Override

- (BOOL) isValueEqualTo: (id) newValue {
    NSValue *normalizedCurrent = _value ? _value : self.defaultValue;
    NSValue *normalizedNew = newValue ? newValue : self.defaultValue;
    
    if (normalizedCurrent == normalizedNew) return YES;
    if (normalizedCurrent == nil || normalizedNew == nil) return NO;
    return [normalizedCurrent isEqualToValue:normalizedNew];
}

- (NSString *) toString {
    NSSize size = [self.value sizeValue];
    NSArray *elements = [NSArray arrayWithObjects:[NSNumber numberWithDouble:size.width], [NSNumber numberWithDouble:size.height],nil];
    return [elements stringWithParenthesesFromNumberArray];
}

- (void) fromString: (NSString *) stringValue {
    NSArray *elements = [stringValue arrayWithDoublesFromStringWithParentheses];
    NSNumber *width = [elements objectAtIndex:0];
    NSNumber *height = [elements objectAtIndex:1];
    NSSize size = NSMakeSize(width.doubleValue, height.doubleValue);
    self.value = [NSValue valueWithSize:size];
}

@end
