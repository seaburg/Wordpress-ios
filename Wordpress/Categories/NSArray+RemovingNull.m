//
//  NSArray+RemovingNull.m
//  Wordpress
//
//  Created by Evgeniy Yurtaev on 01/01/15.
//  Copyright (c) 2015 Evgeniy Yurtaev. All rights reserved.
//

#import "NSArray+RemovingNull.h"
#import "NSDictionary+RemovingNull.h"

@implementation NSArray (RemovingNull)

- (NSArray *)wp_arrayByRemovingNullValues
{
    NSMutableArray *filteredArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (id item in self) {
        
        if ([item isKindOfClass:[NSArray class]]) {
            NSArray *array = [item wp_arrayByRemovingNullValues];
            if ([array count]) {
                [filteredArray addObject:array];
            }
        } else if ([item isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dictionary = [item wp_dictionaryByRemovingNullValues];
            if ([dictionary count]) {
                [filteredArray addObject:dictionary];
            }
        } else if (item != [NSNull null]) {
            [filteredArray addObject:item];
        }
    }
    return [filteredArray copy];
}

@end
