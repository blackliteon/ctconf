//
//  CTConfiguration.h
//  ctconf
//
//  Created by Dmitry Nikolaev on 05.07.12.
//  Copyright (c) 2012 cocotype.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CTConfiguration : NSObject 

- (CGFloat) declareCGFloatPropertyInObject: (id) object withName: (NSString *) name defaultValue:(CGFloat) defaultVal;

- (void) start;

+ (CTConfiguration *) sharedInstance;
@end
