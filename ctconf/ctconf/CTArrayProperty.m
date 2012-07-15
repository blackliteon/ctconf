//
//  CTArrayProperty.m
//  ctconf
//
//  Created by Dmitry Nikolaev on 15.07.12.
//  Copyright (c) 2012 cocotype.com. All rights reserved.
//

#import "CTArrayProperty.h"

@implementation CTArrayProperty

#pragma mark - Property Override

- (BOOL) isValueEqualTo: (id) otherValue {
    NSArray *myArray = self.value;
    NSArray *otherArray = otherValue;
    
    return [myArray isEqualToArray:otherArray];
}

@end
