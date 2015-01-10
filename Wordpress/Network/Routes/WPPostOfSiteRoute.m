//
//  WPPostOfSiteRoute.m
//  Wordpress
//
//  Created by Evgeniy Yurtaev on 10/01/15.
//  Copyright (c) 2015 Evgeniy Yurtaev. All rights reserved.
//

#import "WPPostOfSiteRoute.h"

@implementation WPPostOfSiteRoute

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
        @keypath([WPPostOfSiteRoute new], siteID): @"siteID",
        @keypath([WPPostOfSiteRoute new], postID): @"postID",
    };
}

@end
