//
//  CTIntegerProperty.m
//  ctconf
//
//  Created by Dmitry Nikolaev on 12.07.12.
//  Copyright (c) 2012 cocotype.com. All rights reserved.
//

#import "CTIntegerProperty.h"

@implementation CTIntegerProperty

- (void) fromString: (NSString *) stringValue {
    NSInteger scalarVal = [stringValue integerValue];
    self.value = [NSNumber numberWithInteger:scalarVal];
}

@end
