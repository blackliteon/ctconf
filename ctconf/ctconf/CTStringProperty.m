//
//  CTStringProperty.m
//  ctconf
//
//  Created by Dmitry Nikolaev on 08.07.12.
//  Copyright (c) 2012 cocotype.com. All rights reserved.
//

#import "CTStringProperty.h"

@implementation CTStringProperty

- (BOOL) isValueEqualTo: (id) newValue {
    NSString *oldStr = self.value;
    NSString *newStr = newValue;
    
    return [oldStr isEqualToString:newStr];
}

- (NSString *) toString {
    return self.value;
}

- (void) fromString: (NSString *) stringValue {
    self.value = stringValue;
}

@end
