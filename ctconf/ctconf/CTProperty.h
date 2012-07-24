//
//  CTProperty.h
//  ctconf
//
//  Created by Dmitry Nikolaev on 05.07.12.
//  Copyright (c) 2012 cocotype.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CTPropertyListener.h"

enum {
    CTPropertyTypeCGFloat,  
};

typedef NSInteger CTPropertyType;

@class CTObjectSetterInfo;

@interface CTProperty : NSObject {
    @protected
    
    id _value;
}

@property (copy, nonatomic) NSString *name;
@property (assign) CTPropertyType propertyType;
@property (strong, nonatomic) id value;
@property (strong, nonatomic) id defaultValue;

@property (copy, nonatomic) NSString *objectKey;

- (NSString *) toString;
- (void) fromString: (NSString *) stringValue;
- (BOOL) isValueEqualTo: (id) newValue;

- (void) addObjectThatTracksUpdates: (id) object key: (NSString *) key;
- (void) addPropertyListener: (id<CTPropertyListener>) propertyListener;
- (void) removeObjectFromUpdatesTracking: (id) object;
- (void) addAllObjectSetterInfoFromProperty: (CTProperty *) property;
- (NSArray *) allObjectSetterInfo;

@end
