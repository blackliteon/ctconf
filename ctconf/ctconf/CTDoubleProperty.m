//
//  CTDoubleProperty.m
//  ctconf
//
//  Created by Dmitry Nikolaev on 06.07.12.
//  Copyright (c) 2012 cocotype.com. All rights reserved.
//

#import "CTDoubleProperty.h"

@implementation CTDoubleProperty

- (void) fromString: (NSString *) stringValue {
    double scalarVal = [stringValue doubleValue];
    self.value = [NSNumber numberWithDouble:scalarVal];
}

@end
