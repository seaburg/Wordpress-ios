//
//  NSValueTransformer+Factory.m
//  Wordpress
//
//  Created by Evgeniy Yurtaev on 01/01/15.
//  Copyright (c) 2015 Evgeniy Yurtaev. All rights reserved.
//

#import <Mantle/Mantle.h>

static NSString *WPStringByRemovingBackslashEscapesFromString(NSString *string) {
    NSString *result = [string copy];
    NSInteger location = 0;
    while (location < [result length]) {
        
        NSRange range = [result rangeOfString:@"\\" options:0 range:NSMakeRange(location, [result length] - location)];
        if (range.length == 0) {
            break;
        }
        result = [result stringByReplacingCharactersInRange:NSMakeRange(range.location, 1) withString:@""];
        location = NSMaxRange(range);
    }
    return [result copy];
}

@implementation NSValueTransformer (Factory)

+ (instancetype)wp_URLValueTansformer
{
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^id(NSString *value) {
        if (!value) {
            return nil;
        }
        
        NSString *stringURL = WPStringByRemovingBackslashEscapesFromString(value);
        NSURL *URL = [NSURL URLWithString:stringURL];
        
        return URL;
    } reverseBlock:^id(NSURL *value) {
        if (!value) {
            return nil;
        }
        NSString *stringURL = [[value absoluteString] stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"];
        return stringURL;
    }];
}

@end
