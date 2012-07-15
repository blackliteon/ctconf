//
//  CTStringArrayProperty.m
//  ctconf
//
//  Created by Dmitry Nikolaev on 15.07.12.
//  Copyright (c) 2012 cocotype.com. All rights reserved.
//

#import "CTStringArrayProperty.h"
#import "NSArray+CTAdditions.h"
#import "NSString+CTAdditions.h"

@implementation CTStringArrayProperty

- (NSString *) toString {
    return [self.value stringWithParenthesesFromStringArray];
}

- (void) fromString: (NSString *) stringValue {
    self.value = [stringValue arrayWithStringsFromStringWithParentheses];
}

@end
