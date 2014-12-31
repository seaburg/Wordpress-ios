//
//  WPModel.m
//  Wordpress
//
//  Created by Evgeniy Yurtaev on 31/12/14.
//  Copyright (c) 2014 Evgeniy Yurtaev. All rights reserved.
//

#import "WPModel.h"
#import "WPError.h"

@implementation WPModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{};
}

+ (Class)classForParsingJSONDictionary:(NSDictionary *)JSONDictionary
{
    if ([self class] != [WPError class] && JSONDictionary[@"error"] && JSONDictionary[@"message"]) {
        return [WPError class];
    }
    return self;
}

@end
