//
//  CTPropertyManager.h
//  ctconf
//
//  Created by Dmitry Nikolaev on 24.07.12.
//  Copyright (c) 2012 cocotype.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CTProperty;

@protocol CTPropertyManagerDelegate <NSObject>
    
- (void) propertyValueNotFound: (CTProperty *) property;

@end

@interface CTPropertyManager : NSObject

@property (weak, nonatomic) id<CTPropertyManagerDelegate> delegate;

- (void) addProperty: (CTProperty *) property;
- (CTProperty *) propertyByName: (NSString *) name;
- (void) setConfigText: (NSString *) configText;
- (void) unregisterObjectFromUpdates: (id) object;


@end
