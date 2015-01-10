//
//  WPRouter+Posts.h
//  Wordpress
//
//  Created by Evgeniy Yurtaev on 10/01/15.
//  Copyright (c) 2015 Evgeniy Yurtaev. All rights reserved.
//

#import "WPRouter.h"

@class WPSite;

@interface WPRouter (Posts)

// presentPostsScreenWithSite: : -> RACSignal _
- (RACSignal *)presentPostsScreenWithSite:(WPSite *)site;

@end
