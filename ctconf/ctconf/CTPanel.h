//
//  CTPanel.h
//  ctconf
//
//  Created by Dmitry Nikolaev on 06.07.12.
//  Copyright (c) 2012 cocotype.com. All rights reserved.
//

#import <AppKit/AppKit.h>

@protocol CTPanelDelegate <NSObject>
        
- (void) save;

@end


@interface CTPanel : NSPanel 

@property (strong, nonatomic) id<CTPanelDelegate> ctDelegate;

@end
