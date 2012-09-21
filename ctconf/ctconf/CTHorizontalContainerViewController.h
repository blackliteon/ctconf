//
//  AHorizontalContainerViewController.h
//  Writebox
//
//  Created by Dmitry Nikolaev on 17.09.12.
//  Copyright (c) 2012 Apprium. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CTHorizontalContainerView;

@interface CTHorizontalContainerViewController : NSObject

@property (strong, nonatomic, readonly) CTHorizontalContainerView *containerView;

- (id) initWithPropertyName: (NSString *) propertyName;

@end
