//
//  NSArray+CTAdditions.m
//  ctconf
//
//  Created by Dmitry Nikolaev on 15.07.12.
//  Copyright (c) 2012 cocotype.com. All rights reserved.
//

#import "NSArray+CTAdditions.h"
#import "ctconf.h"

@implementation NSArray (CTAdditions)

- (NSString *) _joinStringArrayToStringWithParentheses: (NSArray *) strArray {
    return [NSString stringWithFormat:@"(%@)",[strArray componentsJoinedByString:CT_PROPERTY_ARRAY_ELEMENTS_SEPARATOR]];
}


- (NSString *) stringWithParenthesesFromNumberArray {
    NSMutableArray *strings = [[NSMutableArray alloc] init];
    for (NSNumber *number in self) {
        [strings addObject:[number stringValue]];
    }
    return [self _joinStringArrayToStringWithParentheses:strings];
}

- (NSString *) stringWithParenthesesFromStringArray {
    return [self _joinStringArrayToStringWithParentheses:self];
}


@end
