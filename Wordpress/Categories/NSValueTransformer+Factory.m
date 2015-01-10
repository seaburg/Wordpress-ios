//
//  NSValueTransformer+Factory.m
//  Wordpress
//
//  Created by Evgeniy Yurtaev on 01/01/15.
//  Copyright (c) 2015 Evgeniy Yurtaev. All rights reserved.
//

#import <Mantle/Mantle.h>
#import <libkern/OSAtomic.h>

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

+ (NSValueTransformer *)wp_URLValueTansformer
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

+ (NSValueTransformer *)wp_dateTimeValueTransformer
{
    static OSSpinLock dateFormatterLock = OS_SPINLOCK_INIT;
    static NSDateFormatter *dateFormatter;
    
    if (!dateFormatter) {
        OSSpinLockLock(&dateFormatterLock);
        if (!dateFormatter) {
            dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"YYYY-MM-DDThh:mm:ssTZD"];
        }
        OSSpinLockUnlock(&dateFormatterLock);
    }
    
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^id(NSString *value) {
        if (!value) {
            return nil;
        }
        OSSpinLockLock(&dateFormatterLock);
        NSDate *date = [dateFormatter dateFromString:value];
        OSSpinLockUnlock(&dateFormatterLock);
        
        return date;
    
    } reverseBlock:^id(NSDate *value) {
        if (!value) {
            return nil;
        }
        
        OSSpinLockLock(&dateFormatterLock);
        NSString *result = [dateFormatter stringFromDate:value];
        OSSpinLockUnlock(&dateFormatterLock);
        
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
