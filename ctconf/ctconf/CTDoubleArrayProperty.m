//
//  CTDoubleArray.m
//  ctconf
//
//  Created by Dmitry Nikolaev on 12.07.12.
//  Copyright (c) 2012 cocotype.com. All rights reserved.
//

#import "CTDoubleArrayProperty.h"
#import "CTPropertyHelper.h"

@interface CTDoubleArrayProperty ()

@property (strong, nonatomic) CTPropertyHelper *helper;

@end

@implementation CTDoubleArrayProperty

@synthesize helper = _helper;

#pragma mark - Accesors

- (CTPropertyHelper *) helper {
    if (!_helper) {
        _helper = [[CTPropertyHelper alloc] init];
    }
    return _helper;
}

#pragma mark - Property Override

- (BOOL) isValueEqualTo: (id) otherValue {
    NSArray *myArray = self.value;
    NSArray *otherArray = otherValue;
    
    return [myArray isEqualToArray:otherArray];
}

- (NSString *) toString {
    return [self.helper stringWithParenthesesFromNumberArray:self.value];
}

- (void) fromString: (NSString *) stringValue {
    self.value = [self.helper arrayWithDoublesFromStringWithParentheses:stringValue];
}


@end
