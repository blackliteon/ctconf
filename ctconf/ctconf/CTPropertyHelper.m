//
//  CTPropertyHelper.m
//  ctconf
//
//  Created by Dmitry Nikolaev on 12.07.12.
//  Copyright (c) 2012 cocotype.com. All rights reserved.
//

#import "CTPropertyHelper.h"

#define CT_PROPERTY_ARRAY_ELEMENTS_SEPARATOR @";"

@implementation CTPropertyHelper

- (NSString *) stringWithParenthesesFromNumberArray: (NSArray *) array {
    NSMutableArray *strings = [[NSMutableArray alloc] init];
    
    for (NSNumber *number in array) {
        [strings addObject:[number stringValue]];
    }
    
    return [NSString stringWithFormat:@"(%@)",[strings componentsJoinedByString:CT_PROPERTY_ARRAY_ELEMENTS_SEPARATOR]];
}

- (NSArray *) arrayWithDoublesFromStringWithParentheses: (NSString *) stringValue {
    if (stringValue.length < 3) {
        return nil; // too short
    }
    
    NSString *firstCharStr = [stringValue substringWithRange:NSMakeRange(0, 1)];
    if (![firstCharStr isEqualToString:@"("]) {
        return nil; // first char is not (
    }
    
    NSString *lastCharStr = [stringValue substringFromIndex:stringValue.length-1];
    if (![lastCharStr isEqualToString:@")"]) {
        return nil; // last char is not )
    }
    
    NSString *stringWithoutParenthesis = [stringValue substringWithRange:NSMakeRange(1, stringValue.length - 2)];
    NSArray *stringComponents = [stringWithoutParenthesis componentsSeparatedByString:CT_PROPERTY_ARRAY_ELEMENTS_SEPARATOR];
    
    NSMutableArray *numbers = [[NSMutableArray alloc] init];
    for (NSString *element in stringComponents) {
        double scalarVal = [element doubleValue];
        NSNumber *number = [NSNumber numberWithDouble:scalarVal];
        [numbers addObject:number];
    }
    
    return [NSArray arrayWithArray:numbers];
}


@end
