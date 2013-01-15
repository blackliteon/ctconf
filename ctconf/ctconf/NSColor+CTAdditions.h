//
//  NSColor+CTAdditions.h
//  ctconf
//
//  Created by Dmitry Nikolaev on 15.01.13.
//  Copyright (c) 2013 cocotype.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSColor (CTAdditions)

- (NSString *) confStringValue;
+ (NSColor *) fromConfStringValue: (NSString *) strValue;

@end
