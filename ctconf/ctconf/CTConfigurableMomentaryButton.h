//
//  CTConfigurableMomentaryButton.h
//  ctconf
//
//  Created by Dmitry Nikolaev on 15.01.13.
//  Copyright (c) 2013 cocotype.com. All rights reserved.
//

#import <ctconf/ctconf.h>

@class CTButtonStyle;

@interface CTConfigurableMomentaryButton : CTMomentaryButton

@property (strong, nonatomic, readonly) NSString *stylesName;

- (id) initWithFrame:(NSRect)frame styleName: (NSString *) styleName defaultPath: (NSString *) path;

@end
