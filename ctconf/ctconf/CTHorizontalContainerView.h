//
//  ATopPanelContainerView.h
//  WriteBoxLib
//
//  Created by Dmitry Nikolaev on 16.07.12.
//  Copyright (c) 2012 Apprium. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef NSString * CTHorizontalContainerItemsAlignment;

extern NSString * const CTHorizontalContainerLeftAlignment;
extern NSString * const CTHorizontalContainerCenterAlignment;

@interface CTHorizontalContainerView : NSView

@property (copy,nonatomic) NSColor *backgroundColor;
@property (assign, nonatomic) CGFloat itemsSpace;
@property (assign, nonatomic) BOOL highlight; // for testing purpose, add little darknening to background
@property (copy, nonatomic) CTHorizontalContainerItemsAlignment alignment;
@property (assign, nonatomic) CGFloat leftMargin; // for left alignment
@property (assign, nonatomic) CGFloat horizontalCorrection;

@property (assign, nonatomic) CGFloat leftItemsSpacing; // for left alignment
@property (assign, nonatomic) BOOL centerAlignmentConsiderSideItems;

- (void) addItem: (NSView *) view;
- (void) addLeftItem: (NSView *) view;

@end
