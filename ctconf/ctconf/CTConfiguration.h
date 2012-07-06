//
//  CTConfiguration.h
//  ctconf
//
//  Created by Dmitry Nikolaev on 05.07.12.
//  Copyright (c) 2012 cocotype.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CTPanel.h"

@interface CTConfiguration : NSObject <CTPanelDelegate>

- (CGFloat) declareCGFloatPropertyInObject: (id) object withName: (NSString *) name defaultValue:(CGFloat) defaultVal;

- (void) start;
- (void) startWithConfigurer;
- (void) startProduction;

+ (CTConfiguration *) sharedInstance;
@end
