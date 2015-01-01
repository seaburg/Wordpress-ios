//
//  WPGetSiteRequest.h
//  Wordpress
//
//  Created by Evgeniy Yurtaev on 01/01/15.
//  Copyright (c) 2015 Evgeniy Yurtaev. All rights reserved.
//

#import "WPRequest.h"

@interface WPGetSiteRequest : WPRequest

// returns specified fields only.
@property (copy, nonatomic) NSArray *fields;

@end
