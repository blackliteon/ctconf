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

- (BOOL) isValueEqualTo: (id) other {
    NSValue *myValue = self.value;
    NSValue *otherValue = other;
    
    return [myValue isEqualToValue:otherValue];
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
