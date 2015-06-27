//
//  NSValueTransformer+Factory.m
//  Wordpress
//
//  Created by Evgeniy Yurtaev on 01/01/15.
//  Copyright (c) 2015 Evgeniy Yurtaev. All rights reserved.
//

#import <Mantle/Mantle.h>
#import <libkern/OSAtomic.h>

@implementation NSValueTransformer (Factory)

+ (NSValueTransformer *)wp_URLValueTansformer
{
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^id(NSString *value) {
        if ([value length] < 1) {
            return nil;
        }
        NSURL *URL = [NSURL URLWithString:value];
        
        return URL;
    } reverseBlock:^id(NSURL *value) {
        
        NSString *stringURL = [value absoluteString];
        return stringURL;
    }];
}

+ (NSValueTransformer *)wp_dateTimeValueTransformer
{
    static NSDateFormatter *dateFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"YYYY'-'MM'-'DD'T'HH':'mm':'sszzz"];
    });
    
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^id(NSString *value) {
        if (!value) {
            return nil;
        }
        NSDate *date = [dateFormatter dateFromString:value];
        
        return date;
    
    } reverseBlock:^id(NSDate *value) {
        if (!value) {
            return nil;
        }
        NSString *result = [dateFormatter stringFromDate:value];
        
        return result;
    }];
}

+ (NSValueTransformer *)wp_arrayValueTransformer
{
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^id(NSString *value) {
        return [value componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@","]];
    } reverseBlock:^id(NSArray *value) {
        return [value componentsJoinedByString:@","];
    }];
}

@end
