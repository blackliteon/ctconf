//
//  NSDictionary+CTAdditions.m
//  ctconf
//
//  Created by Dmitry Nikolaev on 15.01.13.
//  Copyright (c) 2013 cocotype.com. All rights reserved.
//

#import "NSDictionary+CTAdditions.h"
#import "ctconf.h"

@implementation NSDictionary (CTAdditions)

- (NSString *) stringOrdered: (NSArray *) orderedKeys {
    NSMutableArray *pairs = [[NSMutableArray alloc] init];
    
    for (NSString *key in orderedKeys) {
        NSString *pair = [NSString stringWithFormat:@"%@:%@", key, [self objectForKey:key]];
        [pairs addObject:pair];
    }
    
    return [NSString stringWithFormat:@"{%@}", [pairs componentsJoinedByString:CT_PROPERTY_ARRAY_ELEMENTS_SEPARATOR]];
}

@end
