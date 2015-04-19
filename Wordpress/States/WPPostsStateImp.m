//
//  WPPostsStateImp.m
//  Wordpress
//
//  Created by Evgeniy Yurtaev on 19/04/15.
//  Copyright (c) 2015 Evgeniy Yurtaev. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>

#import "WPPostsStateImp.h"
#import "WPPostsItemStateImp.h"

@interface WPPostsState ()

@property (copy, nonatomic) RACSequence *posts;

@property (assign, nonatomic) BOOL nextPageExist;

@end

@implementation WPPostsState

+ (instancetype)emptyState
{
    return [[self alloc] init];
}

- (instancetype)stateBySettingPosts:(RACSequence *)posts
{
    WPPostsState *nextState = [self copy];
    nextState.posts = posts;

    return nextState;
}

- (instancetype)stateByAppendingPosts:(RACSequence *)posts
{
    WPPostsState *nextState = [self copy];
    if (nextState.posts) {
        nextState.posts = [nextState.posts concat:posts];
    } else {
        nextState.posts = posts;
    }
    return nextState;
}

- (instancetype)stateBySettingExistNextPage:(BOOL)nextPageExist
{
    if (self.nextPageExist == nextPageExist) return self;

    WPPostsState *nextState = [self copy];
    nextState.nextPageExist = nextPageExist;

    return nextState;
}

- (RACSequence *)items
{
    return [self.posts map:^id(WPPost *value) {
        return [[WPPostsItemState alloc] initWithPost:value];
    }];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    WPPostsState *copyState = [[[self class] alloc] init];
    copyState.posts = self.posts;
    copyState.nextPageExist = self.nextPageExist;

    return copyState;
}

@end
