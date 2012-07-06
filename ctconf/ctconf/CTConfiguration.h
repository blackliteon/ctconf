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

- (CGFloat) declareDoubleInObject: (id) object withName: (NSString *) name defaultValue:(CGFloat) defaultVal;
- (CGFloat) declareBooleanInObject: (id) object withName: (NSString *) name defaultValue:(BOOL) defaultVal;

- (void) start;
- (void) startDevelopmentVersion;
- (void) startProductionVersion;

+ (CTConfiguration *) sharedInstance;
@end
