//
//  WPSite.m
//  Wordpress
//
//  Created by Evgeniy Yurtaev on 01/01/15.
//  Copyright (c) 2015 Evgeniy Yurtaev. All rights reserved.
//

#import "WPSite.h"

#import "NSValueTransformer+Factory.h"

@implementation WPSite

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSMutableDictionary *keyPaths = [NSMutableDictionary dictionaryWithDictionary:[super JSONKeyPathsByPropertyKey]];
    [keyPaths addEntriesFromDictionary:@{
        @keypath([WPSite new], siteID): @"ID",
        @keypath([WPSite new], name): @"name",
        @keypath([WPSite new], descriptionOfSite): @"description",
        @keypath([WPSite new], URL): @"URL",
        @keypath([WPSite new], postsCount): @"post_count",
        @keypath([WPSite new], subscribersCount): @"subscribers_count",
        @keypath([WPSite new], iconURL): @"icon.img",
        @keypath([WPSite new], smallIconURL): @"icon.ico",
        @keypath([WPSite new], visible): @"visible",
        @keypath([WPSite new], isPrivate): @"is_private",
        @keypath([WPSite new], isFollowing): @"is_following",
    }];
    
    return [keyPaths copy];
}

+ (NSValueTransformer *)URLJSONTransformer
{
    return [NSValueTransformer wp_URLValueTansformer];
}

+ (NSValueTransformer *)iconURLJSONTransformer
{
    return [NSValueTransformer wp_URLValueTansformer];
}

+ (NSValueTransformer *)smallIconURLJSONTransformer
{
    return [NSValueTransformer wp_URLValueTansformer];
}

@end
