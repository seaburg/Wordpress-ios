//
//  WPPostsViewModelImp.m
//  Wordpress
//
//  Created by Evgeniy Yurtaev on 19/04/15.
//  Copyright (c) 2015 Evgeniy Yurtaev. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>

#import "WPPostsViewModelImp.h"
#import "WPPostsStateImp.h"
#import "WPSite.h"
#import "WPStateMachineImp.h"
#import "WPGetPostsRequest.h"
#import "WPPostsResponse.h"
#import "WPClient.h"

#import "WPRouter+Post.h"

static NSInteger WPPostsPageSize = 25;

@interface WPPostsViewModel ()

@property (strong, nonatomic) WPStateMachine *stateMachine;

@property (strong, nonatomic) WPSite *site;

@property (weak, nonatomic) WPRouter *router;

@end

@implementation WPPostsViewModel

- (instancetype)initWithSite:(WPSite *)site
{
    self = [super init];
    if (self) {
        self.stateMachine = [[WPStateMachine alloc] initWithStartState:[WPPostsState emptyState]];
        self.site = site;
    }
    return self;
}

- (RACSignal *)prepareForUse
{
    return [self reloadData];
}

- (RACSignal *)state
{
    return self.stateMachine.stateChanged;
}

- (RACSignal *)reloadData
{
    return [[self loadPostsWithSite:self.site offset:0 pageSize:WPPostsPageSize]
        flattenMap:^RACStream *(WPPostsResponse *value) {
            BOOL nextPageExist = ([value.posts count] < [[value totalObjects] integerValue]);

            return [self.stateMachine pushTransition:^id(WPPostsState *state) {
                WPPostsState *nextState = [state stateBySettingPosts:value.posts.rac_sequence];
                nextState = [nextState stateBySettingExistNextPage:nextPageExist];

                return nextState;
            }];
        }];
}

- (RACSignal *)loadNextPage
{
    return [[self.stateMachine.stateChanged take:1] flattenMap:^RACStream *(WPPostsState *value) {
        NSInteger offset = [value.posts.array count];

        return [[self loadPostsWithSite:self.site offset:offset pageSize:WPPostsPageSize]
            flattenMap:^RACStream *(WPPostsResponse *value) {
                BOOL nextPageExist = (offset + [value.posts count] < [[value totalObjects] integerValue]);

                return [self.stateMachine pushTransition:^id(WPPostsState *state) {
                    WPPostsState *nextState = [state stateByAppendingPosts:value.posts.rac_sequence];
                    nextState = [nextState stateBySettingExistNextPage:nextPageExist];

                    return nextState;
                }];
            }];
    }];
}

- (RACSignal *)selectPostsItemState:(id<WPPostsItemState>)postsItemState
{
    return [[self.stateMachine.stateChanged
        take:1]
        flattenMap:^RACStream *(WPPostsState *value) {
            NSInteger index = [[[value items] array] indexOfObject:postsItemState];
            if (index == NSNotFound) return [RACSignal empty];

            WPPost *selectedPost = [[value.posts skip:index] head];

            return [self.router presentPostScreenWithPost:selectedPost];
        }];
}

#pragma mark - Private methods

- (RACSignal *)loadPostsWithSite:(WPSite *)site offset:(NSInteger)offset pageSize:(NSInteger)pageSize
{
    WPGetPostsRequest *request = [[WPGetPostsRequest alloc] init];
    request.routeObject = site;
    request.fields = @[@"ID", @"site_ID", @"author", @"title", @"excerpt", @"comment_count", @"featured_image" ];
    [request setOffset:@(offset)];
    [request setNumber:@(pageSize)];

    return [[WPClient sharedInstance] performRequest:request];
}

@end
