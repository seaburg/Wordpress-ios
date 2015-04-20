//
//  WPPostStateImp.h
//  Wordpress
//
//  Created by Evgeniy Yurtaev on 20/04/15.
//  Copyright (c) 2015 Evgeniy Yurtaev. All rights reserved.
//

#import "WPPostState.h"

@class WPPost;

@interface WPPostState : NSObject <WPPostState, NSCopying>

@property (strong, nonatomic, readonly) WPPost *post;

+ (instancetype)emptyState;

- (instancetype)stateBySettingPost:(WPPost *)post;

@end
