//
//  CTObjectKey.h
//  ctconf
//
//  Created by Dmitry Nikolaev on 12.07.12.
//  Copyright (c) 2012 cocotype.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CTObjectKey : NSObject

@property (strong) id object;
@property (copy) NSString *key;

@end
