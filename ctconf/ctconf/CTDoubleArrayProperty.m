//
//  CTDoubleArray.m
//  ctconf
//
//  Created by Dmitry Nikolaev on 12.07.12.
//  Copyright (c) 2012 cocotype.com. All rights reserved.
//

#import "CTDoubleArrayProperty.h"
#import "NSArray+CTAdditions.h"
#import "NSString+CTAdditions.h"

@implementation CTDoubleArrayProperty

- (NSString *) toString {
    return [self.value stringWithParenthesesFromNumberArray];
}

- (void) fromString: (NSString *) stringValue {
    self.value = [stringValue arrayWithDoublesFromStringWithParentheses];
}


@end
