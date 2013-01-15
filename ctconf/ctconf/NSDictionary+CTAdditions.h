//
//  NSDictionary+CTAdditions.h
//  ctconf
//
//  Created by Dmitry Nikolaev on 15.01.13.
//  Copyright (c) 2013 cocotype.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (CTAdditions)

- (NSString *) stringOrdered: (NSArray *) orderedKeys;

@end
