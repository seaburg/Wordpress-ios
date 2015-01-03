//
//  NSString+RemovingHTMLElements.h
//  Wordpress
//
//  Created by Evgeniy Yurtaev on 03/01/15.
//  Copyright (c) 2015 Evgeniy Yurtaev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (RemovingHTMLElements)

- (NSString *)wp_stringByRemovingHTMLElements;

@end
