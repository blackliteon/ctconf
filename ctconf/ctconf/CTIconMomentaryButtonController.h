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

- (id) initWithImageTemplatePathPropertyName: (NSString *) templatePathProperty defaultPath: (NSString *) defaultPath stylesPropertyName: (NSString *) stylesProperty backgroudColorProperty: (NSString *) backgroundProperty;

- (id) initWithImageTemplatePathPropertyName: (NSString *) templatePathProperty stylesPropertyName: (NSString *) stylesProperty backgroudColorProperty: (NSString *) backgroundProperty;
- (id) initWithTemplatePathName: (NSString *) templatePathProperty defaultPath: (NSString *) defaultPath stylesName: (NSString *) stylesProperty;

@end
