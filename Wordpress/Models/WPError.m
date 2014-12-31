//
//  WPError.m
//  Wordpress
//
//  Created by Evgeniy Yurtaev on 31/12/14.
//  Copyright (c) 2014 Evgeniy Yurtaev. All rights reserved.
//

#import "WPError.h"
#import "WPDefines.h"

@implementation WPError

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
        @keypath([WPError new], type): @"error",
        @keypath([WPError new], message): @"message",
    };
}

- (NSError *)error
{
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
    [userInfo setValue:self.message forKey:NSLocalizedDescriptionKey];
    
    NSError *error = [NSError errorWithDomain:WPAPIErrorDomain code:0 userInfo:userInfo];
    
    return error;
}

@end
