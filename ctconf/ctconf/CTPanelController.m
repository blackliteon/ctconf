//
//  CTPanelController.m
//  ctconf
//
//  Created by Dmitry Nikolaev on 06.07.12.
//  Copyright (c) 2012 cocotype.com. All rights reserved.
//

#import "CTPanelController.h"

@interface CTPanelController ()

@property (unsafe_unretained) IBOutlet NSTextView *textView;


@end

@implementation CTPanelController

@synthesize textView = _textView;

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)loadWindow
{
    [super loadWindow];
}

- (void) setText: (NSString *) text {
    [self.textView setSelectedRange:NSMakeRange(0, self.textView.textStorage.length)];
    [self.textView insertText:text];
}

- (NSString *) text {
    NSString *text = self.textView.textStorage.string;
    return text;
}

@end
