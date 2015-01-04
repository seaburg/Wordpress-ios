//
//  WPGetPostsRequest.h
//  Wordpress
//
//  Created by Evgeniy Yurtaev on 04/01/15.
//  Copyright (c) 2015 Evgeniy Yurtaev. All rights reserved.
//

#import "WPRequest.h"

@interface WPGetPostsRequest : WPRequest

@property (copy, nonatomic) NSArray *fields;

@property (strong, nonatomic) NSNumber *number;

@property (strong, nonatomic) NSNumber *offset;

@end
