//
//  CTButtonStyle.h
//  ctconf
//
//  Created by Dmitry Nikolaev on 15.01.13.
//  Copyright (c) 2013 cocotype.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CTButtonStyle : NSObject <NSCopying>

@property (copy, nonatomic) NSString *path;
@property (copy, nonatomic) NSColor *tintBackground;
@property (copy, nonatomic) NSColor *color;
@property (copy, nonatomic) NSColor *colorOver;
@property (copy, nonatomic) NSColor *colorDisabled;
@property (copy, nonatomic) NSColor *colorClicked;

- (NSString *) stringValue;
+ (CTButtonStyle *) buttonStyleFromString: (NSString *) string;

@end
