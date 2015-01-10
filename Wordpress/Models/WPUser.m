//
//  WPUser.m
//  Wordpress
//
//  Created by Evgeniy Yurtaev on 02/01/15.
//  Copyright (c) 2015 Evgeniy Yurtaev. All rights reserved.
//

#import "WPUser.h"

#import "NSValueTransformer+Factory.h"

@implementation WPUser

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSMutableDictionary *keyPath = [NSMutableDictionary dictionaryWithDictionary:[super JSONKeyPathsByPropertyKey]];
    
    [keyPath addEntriesFromDictionary:@{
        @keypath([WPUser new], userID): @"ID",
        @keypath([WPUser new], displayName): @"display_name",
        @keypath([WPUser new], name): @"name",
        @keypath([WPUser new], niceName): @"nice_name",
        @keypath([WPUser new], email): @"email",
        @keypath([WPUser new], primaryBlog): @"primary_blog",
        @keypath([WPUser new], language): @"language",
        @keypath([WPUser new], avatarImageURL): @"avatar_URL",
        @keypath([WPUser new], profileImageURL): @"profile_URL",
    }];
    
    return [keyPath copy];
}

+ (NSValueTransformer *)emailJSONTransformer
{
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^id(id value) {
        if ([value isKindOfClass:[NSString class]]) {
            return value;
        } else {
            return nil;
        }
    } reverseBlock:^id(NSString *value) {
        return value;
    }];
}

+ (NSValueTransformer *)avatarURLJSONTransformer
{
    return [NSValueTransformer wp_URLValueTansformer];
}

+ (NSValueTransformer *)avatarImageURLJSONTransformer
{
    return [NSValueTransformer wp_URLValueTansformer];
}

@end
