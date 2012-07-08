//
//  CTPanelController.m
//  ctconf
//
//  Created by Dmitry Nikolaev on 06.07.12.
//  Copyright (c) 2012 cocotype.com. All rights reserved.
//

#import "CTPanelController.h"

@interface CTPanelController () <NSTextViewDelegate, CTPanelDelegate>

@property (unsafe_unretained) IBOutlet NSTextView *textView;
@property (weak) IBOutlet NSPopUpButton *scenePopup;

@end

@implementation CTPanelController

@synthesize textView = _textView;
@synthesize scenePopup = _scenePopup;
@synthesize scenesNames = _scenesNames;
@synthesize delegate = _delegate;
@synthesize textHasModifications = _textHasModifications;

#pragma mark - Override

- (void)loadWindow
{
    [super loadWindow];
}

- (void) windowDidLoad {
    self.textView.delegate = self;
    ((CTPanel *)self.window).ctDelegate = self;
}

#pragma mark - Delegate

- (BOOL)textView:(NSTextView *)aTextView shouldChangeTextInRange:(NSRange)affectedCharRange replacementString:(NSString *)replacementString {
    if (affectedCharRange.length > 0 || replacementString.length > 0) {
        self.textHasModifications = YES;
    }
    return YES;
}

- (void) save {
    [self.delegate save];
}


#pragma mark - Public


- (id)init {
    self = [super initWithWindowNibName:@"CTPanel"];
    if (self) {
        self.textHasModifications = NO;
    }
    return self;
}

- (void) setText: (NSString *) text {
    [self.textView setSelectedRange:NSMakeRange(0, self.textView.textStorage.length)];
    [self.textView insertText:text];
}

- (void) appendText: (NSString *) text {
    [self.textView setSelectedRange:NSMakeRange(self.textView.string.length, 0)];
    [self.textView insertText:text];
}

- (NSString *) text {
    NSString *text = self.textView.textStorage.string;
    return text;
}

- (void) setScenesNames:(NSArray *)scenesNames {
    [self.scenePopup removeAllItems];
    for (NSString *sceneName in scenesNames) {
        [self.scenePopup addItemWithTitle:sceneName];
    }
}

- (IBAction)newSceneChoosed:(NSPopUpButton *)sender {
    [self.delegate newSceneChoosed:sender.titleOfSelectedItem];
}

- (void) selectSceneWithTitle: (NSString *) title {
    [self.scenePopup selectItemWithTitle:title];
}

@end
