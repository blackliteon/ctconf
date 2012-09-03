//
//  CTFontProperty.m
//  ctconf
//
//  Created by Dmitry Nikolaev on 11.08.12.
//  Copyright (c) 2012 cocotype.com. All rights reserved.
//

#import "CTFontProperty.h"

@implementation CTFontProperty

- (NSString *) _fontToString: (NSFont *) font {
    return [NSString stringWithFormat:@"%@, %f", font.fontName, font.pointSize];
}

- (BOOL) isValueEqualTo: (id) newValue {
    NSFont *normalizedCurrent = _value ? _value : self.defaultValue;
    NSFont *normalizedNew = newValue ? newValue : self.defaultValue;
    
    if (normalizedCurrent == normalizedNew) return YES;
    if (normalizedCurrent == nil || normalizedNew == nil) return NO;
    
    NSString *currentFontStr = [self _fontToString:normalizedCurrent];
    NSString *newFontStr = [self _fontToString:normalizedNew];
    return [currentFontStr isEqualToString:newFontStr];
}

- (NSString *) toString {
    NSFont *currentFont = self.value;    
    return [self _fontToString:currentFont];
}

- (void) fromString: (NSString *) stringValue {
    NSArray *strComponents = [stringValue componentsSeparatedByString:@","];
    
    if (strComponents.count != 2) {
        NSLog(@"Property %@ has invalid string value: %@", self.name, stringValue);
        return;
    }
    
    NSString *fontNameStr = [strComponents objectAtIndex:0];
    NSString *fontSizeStr = [strComponents objectAtIndex:1];
    
    NSString *fontNameSanitized = [fontNameStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *fontSizeSanitized = [fontSizeStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    self.value = [NSFont fontWithName:fontNameSanitized size:[fontSizeSanitized floatValue]];
}
@end
