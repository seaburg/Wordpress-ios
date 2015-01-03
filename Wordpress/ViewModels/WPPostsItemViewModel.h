//
//  WPPostsItemViewModel.h
//  Wordpress
//
//  Created by Evgeniy Yurtaev on 02/01/15.
//  Copyright (c) 2015 Evgeniy Yurtaev. All rights reserved.
//

#import "WPViewModel.h"

@class WPPost;
@class RACSignal;

@interface WPPostsItemViewModel : WPViewModel

@property (copy, nonatomic, readonly) NSString *title;

@property (copy, nonatomic, readonly) NSString *excerpt;

@property (assign, nonatomic, readonly) NSInteger numberOfComments;

- (instancetype)initWithPost:(WPPost *)post;

// image : RACSignal UIImage
- (RACSignal *)image;

@end
