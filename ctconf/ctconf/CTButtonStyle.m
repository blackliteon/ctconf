//
//  CTButtonStyle.m
//  ctconf
//
//  Created by Dmitry Nikolaev on 15.01.13.
//  Copyright (c) 2013 cocotype.com. All rights reserved.
//

#import "CTButtonStyle.h"
#import "NSDictionary+CTAdditions.h"
#import "NSString+CTAdditions.h"
#import "NSColor+FromHex.h"

@implementation CTButtonStyle

- (BOOL) isEqual:(id)object {
    if (object == self) return YES;
    if (!object || ![object isKindOfClass:[self class]]) return NO;
    
    CTButtonStyle *other = object;
    
    if (![other.path isEqualToString:self.path]) return NO;
    if (![other.tintBackground isEqual:self.tintBackground]) return NO;
    if (![other.color isEqual:self.color]) return NO;
    if (![other.colorOver isEqual:self.colorOver]) return NO;
    if (![other.colorDisabled isEqual:self.colorDisabled]) return NO;
    if (![other.colorClicked isEqual:self.colorClicked]) return NO;
    
    return YES;
}

- (NSString *) stringValue {
    NSArray *keys = @[@"path", @"tintBackground", @"color", @"colorOver", @"colorDisabled", @"colorClicked"];
    
    NSDictionary *dict = @{@"path":self.path, @"tintBackground":self.tintBackground.hexString, @"color":self.color.hexString, @"colorOver":self.colorOver.hexString, @"colorDisabled":self.colorDisabled.hexString, @"colorClicked":self.colorClicked.hexString};
    
    return [dict stringOrdered:keys];
}

- (id)copyWithZone:(NSZone *)zone {
    CTButtonStyle *buttonStyle = [[CTButtonStyle alloc] init];
    buttonStyle.path = self.path;
    buttonStyle.tintBackground = self.tintBackground;
    buttonStyle.color = self.color;
    buttonStyle.colorOver = self.colorOver;
    buttonStyle.colorDisabled = self.colorDisabled;
    buttonStyle.colorClicked = self.colorClicked;
    
    return buttonStyle;
}


+ (CTButtonStyle *) buttonStyleFromString: (NSString *) string {
    NSDictionary *dict = [string dictionaryFromString];
    
    CTButtonStyle *buttonStyle = [[CTButtonStyle alloc] init];
    buttonStyle.path = dict[@"path"];
    buttonStyle.tintBackground = [NSColor colorFromHexRGB:dict[@"tintBackground"]];
    buttonStyle.color = [NSColor colorFromHexRGB:dict[@"color"]];
    buttonStyle.colorOver = [NSColor colorFromHexRGB:dict[@"colorOver"]];
    buttonStyle.colorDisabled = [NSColor colorFromHexRGB:dict[@"colorDisabled"]];
    buttonStyle.colorClicked = [NSColor colorFromHexRGB:dict[@"colorClicked"]];
    
    return buttonStyle;
}

@end
