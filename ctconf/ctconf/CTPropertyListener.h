//
//  CTPropertyListener.h
//  ctconf
//
//  Created by Dmitry Nikolaev on 24.07.12.
//  Copyright (c) 2012 cocotype.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CTPropertyListener <NSObject>

- (void) propertyWithName: (NSString *) name updatedToValue: (id) value;

@end
