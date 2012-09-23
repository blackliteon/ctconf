//
//  ATopPanelContainerView.m
//  WriteBoxLib
//
//  Created by Dmitry Nikolaev on 16.07.12.
//  Copyright (c) 2012 Apprium. All rights reserved.
//

#import "CTHorizontalContainerView.h"

NSString * const CTHorizontalContainerLeftAlignment = @"left";
NSString * const CTHorizontalContainerCenterAlignment = @"center";

@interface CTHorizontalContainerView ()

@property (strong, nonatomic) NSMutableArray *items;

@end


@implementation CTHorizontalContainerView

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _alignment = CTHorizontalContainerCenterAlignment;
        _leftMargin = 0;
        _horizontalCorrection = 0;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(frameDidChange:) name:NSViewFrameDidChangeNotification object:self];
    }
    
    return self;
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) _rearrangeItems {
    
    CGFloat x = 0;
    
    if ([self.alignment isEqualToString:CTHorizontalContainerLeftAlignment]) {
        x = (self.leftMargin);
    }
    
    if ([self.alignment isEqualToString:CTHorizontalContainerCenterAlignment]) {
        CGFloat itemsWidth = 0;
        for (NSView *view in self.items) {
            itemsWidth += view.frame.size.width;
        }
        
        CGFloat itemsWidthWithSpacing = itemsWidth + self.itemsSpace * (self.items.count - 1);
        x = (self.bounds.size.width / 2 - itemsWidthWithSpacing / 2);
        
        x += self.horizontalCorrection;
    }
    
    if (self.items.count > 0) {
        
        for (int i = 0; i < self.items.count; i++) {
            
            NSView *view = [self.items objectAtIndex:i];
            CGFloat y = (self.bounds.size.height / 2 - view.frame.size.height / 2);
            [view setFrame:NSMakeRect((int)x, (int)y, view.frame.size.width, view.frame.size.height)];
            
            x += view.frame.size.width + self.itemsSpace;
        }
    }
}

- (void) addItem: (NSView *) view {
    
    if (YES || self.items.count == 0) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemFrameUpdated:) name:NSViewFrameDidChangeNotification object:view];
//        _itemWidth = view.frame.size.width;
    }
    
    [self.items addObject:view];
    [self addSubview:view];
    [self _rearrangeItems];
}

- (void) itemFrameUpdated: (NSNotification *) notification {
    [self _rearrangeItems];
//    NSView *view = notification.object;
//    self.itemWidth = view.frame.size.width;
}

#pragma mark - View

- (void)drawRect:(NSRect)dirtyRect {
    [_backgroundColor setFill];
    NSRectFillUsingOperation(dirtyRect, NSCompositeSourceOver);
}

- (void)frameDidChange:(NSNotification *)aNotification {
    [self _rearrangeItems];
}

#pragma mark - Setters

- (void) setBackgroundColor:(NSColor *)backgroundColor {
    _backgroundColor = [backgroundColor copy];
    [self setNeedsDisplay:YES];
}

- (void) setItemsSpace:(CGFloat)itemsSpace {
    _itemsSpace = itemsSpace;
    [self _rearrangeItems];
}

- (void) setHighlight:(BOOL)highlight {
    _highlight = highlight;
    [self setNeedsDisplay:YES];
}

- (void) setLeftMargin:(CGFloat)leftMargin {
    _leftMargin = leftMargin;
    [self _rearrangeItems];
}

- (void) setAlignment:(CTHorizontalContainerItemsAlignment)alignment {
    _alignment = [alignment copy];
    [self _rearrangeItems];
}

- (void) setHorizontalCorrection:(CGFloat)horizontalCorrection {
    _horizontalCorrection = horizontalCorrection;
    [self _rearrangeItems];
}

#pragma mark - Initializers

- (NSMutableArray *) items {
    if (_items) return _items;
    _items = [[NSMutableArray alloc] init];
    return _items;
}

@end
