//
//  CTEdgeInsetsProperty.m
//  ctconf
//
//  Created by Dmitry Nikolaev on 14.01.13.
//  Copyright (c) 2013 cocotype.com. All rights reserved.
//

#import "CTEdgeInsetsProperty.h"
#import "NSString+CTAdditions.h"
#import "NSArray+CTAdditions.h"
#import "NSValue+EdgeInsets.h"

@implementation CTEdgeInsetsProperty

- (BOOL) isValueEqualTo: (id) newValue {
    NSValue *normalizedCurrent = _value ? _value : self.defaultValue;
    NSValue *normalizedNew = newValue ? newValue : self.defaultValue;
    
    if (normalizedCurrent == normalizedNew) return YES;
    if (normalizedCurrent == nil || normalizedNew == nil) return NO;
    return [normalizedCurrent isEqualToValue:normalizedNew];
}

- (NSString *) toString {
    NSEdgeInsets edgeInsets = [self.value edgeInsetsValue];
    NSArray *elements = [NSArray arrayWithObjects:[NSNumber numberWithDouble:edgeInsets.top], [NSNumber numberWithDouble:edgeInsets.right],[NSNumber numberWithDouble:edgeInsets.bottom],[NSNumber numberWithDouble:edgeInsets.left],nil];
    return [elements stringWithParenthesesFromNumberArray];
}

- (void) fromString: (NSString *) stringValue {
    NSArray *elements = [stringValue arrayWithDoublesFromStringWithParentheses];
    NSNumber *top = [elements objectAtIndex:0];
    NSNumber *right = [elements objectAtIndex:1];
    NSNumber *bottom = [elements objectAtIndex:2];
    NSNumber *left = [elements objectAtIndex:3];
    NSEdgeInsets edgeInsets = NSEdgeInsetsMake(top.doubleValue, left.doubleValue, bottom.doubleValue, right.doubleValue);
    self.value = [NSValue valueWithEdgeInsets:edgeInsets];
}
@end
