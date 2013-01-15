//
//  NSString+CTAdditions.h
//  ctconf
//
//  Created by Dmitry Nikolaev on 15.07.12.
//  Copyright (c) 2012 cocotype.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (CTAdditions)

- (NSArray *) arrayWithDoublesFromStringWithParentheses;
- (NSArray *) arrayWithStringsFromStringWithParentheses;
- (NSDictionary *) dictionaryFromString;
@end
