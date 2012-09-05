//
//  CTMomentaryLabelController.h
//  ctconf
//
//  Created by Dmitry Nikolaev on 04.09.12.
//  Copyright (c) 2012 cocotype.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CTMomentaryButton;

@interface CTMomentaryButtonWithLabelController : NSObject

@property (copy, nonatomic) NSString *text;
@property (strong, readonly, nonatomic) CTMomentaryButton *button;
@property (strong, readonly, nonatomic) NSString *propertyName;

- (id) initWithPropertyName: (NSString *) name text: (NSString *) text;

@end
