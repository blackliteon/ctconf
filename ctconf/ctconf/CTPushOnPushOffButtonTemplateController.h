//
//  CTPushOnPushOffButtonTemplateController.h
//  ctconf
//
//  Created by Dmitry Nikolaev on 05.09.12.
//  Copyright (c) 2012 cocotype.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CTPushOnPushOffButton;

@interface CTPushOnPushOffButtonTemplateController : NSObject

@property (strong, nonatomic, readonly) NSString *stylesPropertyName;
@property (strong, nonatomic, readonly) NSString *backgroundPropertyName;
@property (strong, nonatomic, readonly) CTPushOnPushOffButton *button;
@property (strong, nonatomic, readonly) NSString *templatePathProperty;

- (id) initWithImageTemplatePathPropertyName: (NSString *) templatePathProperty stylesPropertyName: (NSString *) stylesProperty backgroudColorProperty: (NSString *) backgroundProperty;

@end
