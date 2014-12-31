//
//  WPRequest.m
//  Wordpress
//
//  Created by Evgeniy Yurtaev on 31/12/14.
//  Copyright (c) 2014 Evgeniy Yurtaev. All rights reserved.
//

#import "WPRequest.h"

@implementation WPRequest

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
        @keypath([WPRequest new], routeObjects): [NSNull null],
    };
}

+ (NSString *)pathPattern
{
    NSAssert(NO, @"should be overridden in subclasses");
    return nil;
}

+ (NSString *)method
{
    NSAssert(NO, @"should be overridden in subclasses");
    return nil;
}

+ (Class)responseClass
{
    NSAssert(NO, @"should be overridden in subclasses");
    return nil;
}

@end
