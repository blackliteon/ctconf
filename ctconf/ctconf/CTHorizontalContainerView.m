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
@property (strong, nonatomic) NSMutableArray *leftItems;
@property (strong, nonatomic) NSMutableArray *rightItems;

@end


@implementation CTHorizontalContainerView

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _alignment = CTHorizontalContainerCenterAlignment;
        _leftMargin = 0;
        _horizontalCorrection = 0;
        _centerAlignmentConsiderSideItems = NO;
        _leftItemsSpacing = 0;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(frameDidChange:) name:NSViewFrameDidChangeNotification object:self];
    }
    
    return self;
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) _rearrangeItems {
    
    // items
    
    CGFloat itemsWidth = 0;
    for (NSView *view in self.items) {
        itemsWidth += view.frame.size.width;
    }
    CGFloat itemsWidthWithSpacing = itemsWidth + self.itemsSpace * (self.items.count - 1);
    
    // left items
    CGFloat leftItemsWidth = 0;
    CGFloat leftItemsWidthWithSpacing = 0;
    
    if (self.leftItems.count) {
    
        for (NSView *view in self.leftItems) {
            leftItemsWidth += view.frame.size.width;
        }
        leftItemsWidthWithSpacing = leftItemsWidth + self.itemsSpace * (self.leftItems.count - 1);
    }
    
    CGFloat x = 0;
    
    //right items
    
    CGFloat rightItemsWidth = 0;
    CGFloat rightItemsWidthWithSpacing = 0;
    if (self.rightItems.count) {
        for (NSView * view in self.rightItems) {
            rightItemsWidth += view.frame.size.width;
        }
        rightItemsWidthWithSpacing = rightItemsWidth + self.itemsSpace * (self.rightItems.count - 1);
    }
    
    // start x for left alignment
    
    if ([self.alignment isEqualToString:CTHorizontalContainerLeftAlignment]) {
        x = (self.leftMargin);
    }
    
    // start x for center alignment

    CGFloat normalizedLeftItemsSpacing = self.leftItemsSpacing ? self.leftItemsSpacing : self.itemsSpace;
    
    if ([self.alignment isEqualToString:CTHorizontalContainerCenterAlignment]) {
        
        if (self.centerAlignmentConsiderSideItems) {
            CGFloat width = itemsWidthWithSpacing;
            
            if (self.leftItems.count) {
                width += leftItemsWidthWithSpacing + normalizedLeftItemsSpacing;
            }
            
            x = (self.bounds.size.width / 2 - width / 2);
            
        } else {
            
            x = (self.bounds.size.width / 2 - itemsWidthWithSpacing / 2);
            x -= leftItemsWidthWithSpacing;
            
            if (self.leftItems.count) {
                x -= normalizedLeftItemsSpacing;
            }
        }
        
        
        x += self.horizontalCorrection;
    }

    // left items coordinates

    for (int i = 0; i < self.leftItems.count; i++) {
        NSView *view = [self.leftItems objectAtIndex:i];
        CGFloat y = (self.bounds.size.height / 2 - view.frame.size.height / 2);
        [view setFrame:NSMakeRect((int)x, (int)y, view.frame.size.width, view.frame.size.height)];
        
        int lastIndex = (int)self.leftItems.count - 1;
        if (i == lastIndex) {
            x += view.frame.size.width + normalizedLeftItemsSpacing;
        } else {
            x += view.frame.size.width + self.itemsSpace;
        }
        
    }

    // items coordinates
    
    for (int i = 0; i < self.items.count; i++) {
        
        NSView *view = [self.items objectAtIndex:i];
        CGFloat y = (self.bounds.size.height / 2 - view.frame.size.height / 2);
        [view setFrame:NSMakeRect((int)x, (int)y, view.frame.size.width, view.frame.size.height)];
        
        x += view.frame.size.width + self.itemsSpace;
    }
    
    // right items coordinates
    
    x = self.frame.size.width - self.rightItemsRightMargin - rightItemsWidthWithSpacing;
    
    for (int i = 0; i < self.rightItems.count; i++) {
        NSView *view = [self.rightItems objectAtIndex:i];
        CGFloat y = (self.bounds.size.height / 2 - view.frame.size.height / 2);
        [view setFrameOrigin:NSMakePoint((int)x, (int)y)];

        x += view.frame.size.width + self.itemsSpace;
    }
}

- (void) addItem: (NSView *) view {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemFrameUpdated:) name:NSViewFrameDidChangeNotification object:view];
    
    [self.items addObject:view];
    [self addSubview:view];
    [self _rearrangeItems];
}

- (void) addLeftItem: (NSView *) view {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemFrameUpdated:) name:NSViewFrameDidChangeNotification object:view];
    
    [self.leftItems addObject:view];
    [self addSubview:view];
    [self _rearrangeItems];
}

- (void) addRightItem: (NSView *) view {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemFrameUpdated:) name:NSViewFrameDidChangeNotification object:view];
    
    [self.rightItems addObject:view];
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

- (void) setLeftItemsSpacing:(CGFloat)leftItemsSpacing {
    _leftItemsSpacing = leftItemsSpacing;
    [self _rearrangeItems];
}

- (void) setCenterAlignmentConsiderSideItems:(BOOL)centerAlignmentConsiderSideItems {
    _centerAlignmentConsiderSideItems = centerAlignmentConsiderSideItems;
    [self _rearrangeItems];
}

- (void) setRightItemsRightMargin:(CGFloat)rightItemsRightMargin {
    _rightItemsRightMargin = rightItemsRightMargin;
    [self _rearrangeItems];
}

#pragma mark - Initializers

- (NSMutableArray *) items {
    if (_items) return _items;
    _items = [[NSMutableArray alloc] init];
    return _items;
}

- (NSMutableArray *) leftItems {
    if (_leftItems) return _leftItems;
    _leftItems = [[NSMutableArray alloc] init];
    return _leftItems;
}

- (NSMutableArray *) rightItems {
    if (_rightItems) return _rightItems;
    _rightItems = [[NSMutableArray alloc] init];
    return _rightItems;
}

@end
