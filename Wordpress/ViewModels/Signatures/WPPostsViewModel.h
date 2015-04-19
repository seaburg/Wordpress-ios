//
//  WPPostsViewModel.h
//  Wordpress
//
//  Created by Evgeniy Yurtaev on 19/04/15.
//  Copyright (c) 2015 Evgeniy Yurtaev. All rights reserved.
//

#import "WPPostsItemState.h"

@class RACSignal;

@protocol WPPostsViewModel <NSObject>

// state : -> RACSignal WPPostsState
- (RACSignal *)state;

// reloadData : -> RACSignal _
- (RACSignal *)reloadData;

// loadNextPage : -> RACSignal _
- (RACSignal *)loadNextPage;

// selectPostAtIndex: : -> RACSignal _
- (RACSignal *)selectPostsItemState:(id<WPPostsItemState>)postsItemState;

@end
