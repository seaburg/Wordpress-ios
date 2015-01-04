//
//  WPPostsResponse.m
//  Wordpress
//
//  Created by Evgeniy Yurtaev on 04/01/15.
//  Copyright (c) 2015 Evgeniy Yurtaev. All rights reserved.
//

#import "WPPostsResponse.h"
#import "WPPost.h"

@implementation WPPostsResponse

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
        @keypath([WPPostsResponse new], found) : @"found",
        @keypath([WPPostsResponse new], posts) : @"posts",
    };
}

+ (NSValueTransformer *)postsJSONTransformer
{
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^id(NSArray *value) {
        if (![value isKindOfClass:[NSArray class]]) {
            return nil;
        }
        
        NSError *error;
        NSArray *result = [MTLJSONAdapter modelsOfClass:[WPPost class] fromJSONArray:value error:&error];
        if (error) {
            NSLog(@"%@", error);
        }
        
        return result;
        
    } reverseBlock:^id(NSArray *value) {
        if (!value) {
            return nil;
        }
        return [MTLJSONAdapter JSONArrayFromModels:value];
    }];
}

@end
