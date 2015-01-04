//
//  WPGetPostsRequest.m
//  Wordpress
//
//  Created by Evgeniy Yurtaev on 04/01/15.
//  Copyright (c) 2015 Evgeniy Yurtaev. All rights reserved.
//

#import "WPGetPostsRequest.h"
#import "WPPostsResponse.h"

@implementation WPGetPostsRequest

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSMutableDictionary *keyPaths = [NSMutableDictionary dictionaryWithDictionary:[super JSONKeyPathsByPropertyKey]];
    
    [keyPaths addEntriesFromDictionary:@{
        @keypath([WPGetPostsRequest new], fields): @"fields",
        @keypath([WPGetPostsRequest new], number): @"number",
        @keypath([WPGetPostsRequest new], offset): @"offset",
    }];
    
    return [keyPaths copy];
}

+ (NSString *)pathPattern
{
    return @"sites/:ID/posts/";
}

+ (NSString *)method
{
    return @"GET";
}

+ (Class)responseClass
{
    return [WPPostsResponse class];
}

@end
