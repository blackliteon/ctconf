//
//  CTConfFunctions.h
//  ctconf
//
//  Created by Dmitry Nikolaev on 14.01.13.
//  Copyright (c) 2013 cocotype.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CTButtonStyle.h"


void confInit(void);

CGFloat confDouble (NSString *propertyName, id object, NSString *objectKey, CGFloat defaultValue) ;

NSFont* confFont (NSString *propertyName, id object, NSString *objectKey, NSFont *defaultValue) ;
NSColor* confColor (NSString *propertyName, id object, NSString *objectKey, NSColor *defaultValue) ;
NSEdgeInsets confEdgeInsets (NSString *propertyName, id object, NSString *objectKey, NSEdgeInsets defaultValue) ;

CTButtonStyle* confButtonStyle (NSString *propertyName, id object, NSString *objectKey, CTButtonStyle *defaultValue);

NSRect confRect (NSString *propertyName, id object, NSString *objectKey, NSRect defaultValue) ;

/* */

void confUnregister (id object);