//
//  WPRouter+Post.h
//  Wordpress
//
//  Created by Evgeniy Yurtaev on 10/01/15.
//  Copyright (c) 2015 Evgeniy Yurtaev. All rights reserved.
//

#import "WPRouter.h"

@class WPPost;

@interface WPRouter (Post)

// presentPostScreenWithPost: : -> RACSignal _
- (RACSignal *)presentPostScreenWithPost:(WPPost *)post;

@end
