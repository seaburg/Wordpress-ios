//
//  WPPostsItemStateImp.h
//  Wordpress
//
//  Created by Evgeniy Yurtaev on 19/04/15.
//  Copyright (c) 2015 Evgeniy Yurtaev. All rights reserved.
//

#import "WPPostsItemState.h"

@class WPPost;

@interface WPPostsItemState : NSObject <WPPostsItemState>

- (instancetype)initWithPost:(WPPost *)post NS_DESIGNATED_INITIALIZER;

@end
