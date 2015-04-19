//
//  WPPostsStateImp.h
//  Wordpress
//
//  Created by Evgeniy Yurtaev on 19/04/15.
//  Copyright (c) 2015 Evgeniy Yurtaev. All rights reserved.
//

#import "WPPostsState.h"

@interface WPPostsState : NSObject <WPPostsState, NSCopying>

@property (copy, nonatomic, readonly) RACSequence *posts;

+ (instancetype)emptyState;

- (instancetype)stateBySettingPosts:(RACSequence *)posts;

- (instancetype)stateByAppendingPosts:(RACSequence *)posts;

- (instancetype)stateBySettingExistNextPage:(BOOL)nextPageExist;

@end
