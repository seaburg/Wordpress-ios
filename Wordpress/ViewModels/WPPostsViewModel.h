//
//  WPPostsViewModel.h
//  Wordpress
//
//  Created by Evgeniy Yurtaev on 04/01/15.
//  Copyright (c) 2015 Evgeniy Yurtaev. All rights reserved.
//

#import "WPViewModel.h"

@class WPPaginator;
@class WPPostsItemViewModel;
@class RACSignal;

@interface WPPostsViewModel : WPViewModel

@property (assign, nonatomic, readonly) BOOL nextPageExisted;

@property (assign, nonatomic, readonly) NSInteger numberOfObjets;

- (instancetype)initWithPaginator:(WPPaginator *)paginator;

// reloadData : -> RACSignal _
- (RACSignal *)reloadData;

// loadNextPage : -> RACSignal _
- (RACSignal *)loadNextPage;

- (WPPostsItemViewModel *)itemViewModelAtIndex:(NSInteger)index;

@end
