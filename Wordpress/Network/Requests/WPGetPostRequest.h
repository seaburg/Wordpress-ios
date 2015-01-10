//
//  WPGetPostRequest.h
//  Wordpress
//
//  Created by Evgeniy Yurtaev on 10/01/15.
//  Copyright (c) 2015 Evgeniy Yurtaev. All rights reserved.
//

#import "WPRequest.h"

@interface WPGetPostRequest : WPRequest

// Returns specified fields only.
@property (copy, nonatomic) NSArray *fields;

@end
