//
//  NSString+RemovingHTMLElements.m
//  Wordpress
//
//  Created by Evgeniy Yurtaev on 03/01/15.
//  Copyright (c) 2015 Evgeniy Yurtaev. All rights reserved.
//

#import "NSString+RemovingHTMLElements.h"

@implementation NSString (RemovingHTMLElements)

- (NSString *)wp_stringByRemovingHTMLElements
{
    NSString *stringWithoutHTMLElements = [self stringByReplacingOccurrencesOfString:@"<[^>]+>"
                                                                          withString:@""
                                                                             options:NSRegularExpressionSearch
                                                                               range:NSMakeRange(0, [self length])];
    return stringWithoutHTMLElements;
}

@end
