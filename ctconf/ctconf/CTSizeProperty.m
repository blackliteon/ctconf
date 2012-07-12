//
//  CTSizeProperty.m
//  ctconf
//
//  Created by Dmitry Nikolaev on 12.07.12.
//  Copyright (c) 2012 cocotype.com. All rights reserved.
//

#import "CTSizeProperty.h"
#import "CTPropertyHelper.h"

@interface CTSizeProperty ()

@property (strong, nonatomic) CTPropertyHelper *helper;

@end

@implementation CTSizeProperty

@synthesize helper = _helper;

#pragma mark - Accesors

- (CTPropertyHelper *) helper {
    if (!_helper) {
        _helper = [[CTPropertyHelper alloc] init];
    }
    return _helper;
}

#pragma mark - Property Override

- (BOOL) isValueEqualTo: (id) other {
    NSValue *myValue = self.value;
    NSValue *otherValue = other;
    
    return [myValue isEqualToValue:otherValue];
}

- (NSString *) toString {
    NSSize size = [self.value sizeValue];
    
    NSArray *elements = [NSArray arrayWithObjects:[NSNumber numberWithDouble:size.width], [NSNumber numberWithDouble:size.height],nil];
    
    return [self.helper stringWithParenthesesFromNumberArray:elements];
}

- (void) fromString: (NSString *) stringValue {
    NSArray *elements = [self.helper arrayWithDoublesFromStringWithParentheses:stringValue];
    NSNumber *width = [elements objectAtIndex:0];
    NSNumber *height = [elements objectAtIndex:1];
    NSSize size = NSMakeSize(width.doubleValue, height.doubleValue);
    self.value = [NSValue valueWithSize:size];
}

@end
