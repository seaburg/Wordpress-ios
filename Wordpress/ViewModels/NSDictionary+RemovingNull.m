//
//  NSDictionary+RemovingNull.m
//  Wordpress
//
//  Created by Evgeniy Yurtaev on 01/01/15.
//  Copyright (c) 2015 Evgeniy Yurtaev. All rights reserved.
//

#import "NSDictionary+RemovingNull.h"
#import "NSArray+RemovingNull.h"

@implementation NSDictionary (RemovingNull)

- (NSDictionary *)wp_dictionaryByRemovingNullValues
{
    NSMutableDictionary *filteredDictionary = [NSMutableDictionary dictionaryWithCapacity:[self count]];
    for (id<NSCopying> key in self) {
        
        id value = self[key];
        if ([value isKindOfClass:[NSArray class]]) {
            NSArray *array = [value wp_arrayByRemovingNullValues];
            if ([array count]) {
                filteredDictionary[key] = array;
            }
        } else if ([value isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dictionary = [value wp_dictionaryByRemovingNullValues];
            if ([dictionary count]) {
                filteredDictionary[key] = dictionary;
            }
        } else if (value != [NSNull null]) {
            filteredDictionary[key] = value;
        }
    }
    return [filteredDictionary copy];
}

@end
