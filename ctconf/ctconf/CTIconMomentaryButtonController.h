//
//  CTIconMomentaryButtonController.h
//  ctconf
//
//  Created by Dmitry Nikolaev on 28.09.12.
//  Copyright (c) 2012 cocotype.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CTMomentaryButton;

@interface CTIconMomentaryButtonController : NSObject

@property (strong, nonatomic, readonly) NSString *stylesPropertyName;
@property (strong, nonatomic, readonly) CTMomentaryButton *button;
@property (strong, nonatomic, readonly) NSString *templatePathProperty;

@end
