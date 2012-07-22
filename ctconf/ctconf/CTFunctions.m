//
//  CTFunctions.m
//  ctconf
//
//  Created by Dmitry Nikolaev on 19.07.12.
//  Copyright (c) 2012 cocotype.com. All rights reserved.
//

#import "CTFunctions.h"

NSRect CTOffsetRectWithSize (NSRect rect, NSSize size) {
    NSRect result = rect;
    result.origin.x += size.width;
    result.origin.y += size.height;
    return result;
}