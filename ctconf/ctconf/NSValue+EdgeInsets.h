//
//  NSValue+EdgeInsets.h
//  ctconf
//
//  Created by Dmitry Nikolaev on 14.01.13.
//  Copyright (c) 2013 cocotype.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSValue (EdgeInsets)

- (NSEdgeInsets) edgeInsetsValue;
+ (id) valueWithEdgeInsets: (NSEdgeInsets) edgeInsets;

@end
