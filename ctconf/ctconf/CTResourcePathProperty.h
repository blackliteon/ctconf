//
//  CTResourcePath.h
//  ctconf
//
//  Created by Dmitry Nikolaev on 15.07.12.
//  Copyright (c) 2012 cocotype.com. All rights reserved.
//

#import "CTProperty.h"

@protocol CTResourcePathDelegate <NSObject>
    
- (NSString *) absolutePathForResourceWithConfigPath: (NSString *) path;

@end

@interface CTResourcePathProperty : CTProperty

@property (weak, nonatomic) id<CTResourcePathDelegate> delegate;

@end
