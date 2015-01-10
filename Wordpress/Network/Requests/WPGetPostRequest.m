//
//  WPGetPostRequest.m
//  Wordpress
//
//  Created by Evgeniy Yurtaev on 10/01/15.
//  Copyright (c) 2015 Evgeniy Yurtaev. All rights reserved.
//

#import "WPGetPostRequest.h"
#import "WPPost.h"

#import "NSValueTransformer+Factory.h"

@implementation WPGetPostRequest

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSMutableDictionary *keyPaths = [NSMutableDictionary dictionaryWithDictionary:[super JSONKeyPathsByPropertyKey]];
    [keyPaths addEntriesFromDictionary:@{
        @keypath([WPGetPostRequest new], fields): @"fields",
    }];
    
    return [keyPaths copy];
}

+ (NSString *)pathPattern
{
    return @"sites/:siteID/posts/:postID";
}

+ (NSString *)method
{
    return @"GET";
}

+ (Class)responseClass
{
    return [WPPost class];
}

+ (NSValueTransformer *)fieldsJSONTransformer
{
    return [NSValueTransformer wp_arrayValueTransformer];
}

@end
