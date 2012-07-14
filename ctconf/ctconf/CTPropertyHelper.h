//
//  CTPropertyHelper.h
//  ctconf
//
//  Created by Dmitry Nikolaev on 12.07.12.
//  Copyright (c) 2012 cocotype.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CTPropertyHelper : NSObject

- (NSString *) stringWithParenthesesFromNumberArray: (NSArray *) array;
- (NSArray *) arrayWithDoublesFromStringWithParentheses: (NSString *) str;

@end