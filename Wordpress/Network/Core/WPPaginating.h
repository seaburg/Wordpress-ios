//
//  WPPaginating.h
//  Wordpress
//
//  Created by Evgeniy Yurtaev on 04/01/15.
//  Copyright (c) 2015 Evgeniy Yurtaev. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WPRequestPaginating <NSObject>

- (void)setOffset:(NSNumber *)offset;
- (void)setNumber:(NSNumber *)number;

@end

@protocol WPResponsePaginating <NSObject>

- (NSArray *)objects;
- (NSNumber *)totalObjects;

@end