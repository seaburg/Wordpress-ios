//
//  WPPostsResponse.h
//  Wordpress
//
//  Created by Evgeniy Yurtaev on 04/01/15.
//  Copyright (c) 2015 Evgeniy Yurtaev. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface WPPostsResponse : MTLModel<MTLJSONSerializing>

@property (strong, nonatomic) NSNumber *found;

@property (copy, nonatomic) NSArray *posts;

@end
