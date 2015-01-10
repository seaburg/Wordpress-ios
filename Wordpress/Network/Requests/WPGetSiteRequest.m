//
//  WPGetSiteRequest.m
//  Wordpress
//
//  Created by Evgeniy Yurtaev on 01/01/15.
//  Copyright (c) 2015 Evgeniy Yurtaev. All rights reserved.
//

#import "WPGetSiteRequest.h"
#import "WPSite.h"

#import "NSValueTransformer+Factory.h"

@implementation WPGetSiteRequest

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSMutableDictionary *keyPaths = [NSMutableDictionary dictionaryWithDictionary:[super JSONKeyPathsByPropertyKey]];
    [keyPaths addEntriesFromDictionary:@{
        @keypath([WPGetSiteRequest new], fields): @"fields",
    }];
    
    return [keyPaths copy];
}

+ (NSString *)pathPattern
{
    return @"sites/:ID";
}

+ (NSString *)method
{
    return @"GET";
}

+ (Class)responseClass
{
    return [WPSite class];
}

+ (NSValueTransformer *)fieldsJSONTransformer
{
    return [NSValueTransformer wp_arrayValueTransformer];
}

@end
