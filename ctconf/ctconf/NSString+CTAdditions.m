//
//  NSString+CTAdditions.m
//  ctconf
//
//  Created by Dmitry Nikolaev on 15.07.12.
//  Copyright (c) 2012 cocotype.com. All rights reserved.
//

#import "NSString+CTAdditions.h"
#import "ctconf.h"

typedef id (^stringElementToArrayElementConverterBlock)(NSString * strEl);

@implementation NSString (CTAdditions)

- (NSArray *) _arrayFromStrinElements: (stringElementToArrayElementConverterBlock) block {
    if (self.length < 3) {
        return nil; // too short
    }
    
    NSString *firstCharStr = [self substringWithRange:NSMakeRange(0, 1)];
    if (![firstCharStr isEqualToString:@"("]) {
        return nil; // first char is not (
    }
    
    NSString *lastCharStr = [self substringFromIndex:self.length-1];
    if (![lastCharStr isEqualToString:@")"]) {
        return nil; // last char is not )
    }
    
    NSString *stringWithoutParenthesis = [self substringWithRange:NSMakeRange(1, self.length - 2)];
    NSArray *stringComponents = [stringWithoutParenthesis componentsSeparatedByString:CT_PROPERTY_ARRAY_ELEMENTS_SEPARATOR];
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (NSString *strElement in stringComponents) {
        id arrayElement = block(strElement);
        [array addObject:arrayElement];
    }
    
    return [NSArray arrayWithArray:array];
}

- (NSArray *) arrayWithDoublesFromStringWithParentheses {
    return [self _arrayFromStrinElements:^id(NSString *strEl) {
        double d = [strEl doubleValue];
        return [NSNumber numberWithDouble:d];
    }];
}

- (NSArray *) arrayWithStringsFromStringWithParentheses {
    return [self _arrayFromStrinElements:^id(NSString *strEl) {
        return strEl;
    }];
}


@end
