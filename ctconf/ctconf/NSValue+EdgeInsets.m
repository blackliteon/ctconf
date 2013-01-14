//
//  NSValue+EdgeInsets.m
//  ctconf
//
//  Created by Dmitry Nikolaev on 14.01.13.
//  Copyright (c) 2013 cocotype.com. All rights reserved.
//

#import "NSValue+EdgeInsets.h"

@implementation NSValue (EdgeInsets)

- (NSEdgeInsets) edgeInsetsValue {
    NSEdgeInsets edgeInsets = NSEdgeInsetsMake(0, 0, 0, 0);
    [self getValue:&edgeInsets];
    return edgeInsets;
}

+ (id) valueWithEdgeInsets: (NSEdgeInsets) edgeInsets {
    NSValue *value = [NSValue valueWithBytes:&edgeInsets objCType:@encode(NSEdgeInsets)];
    return value;
}

@end
