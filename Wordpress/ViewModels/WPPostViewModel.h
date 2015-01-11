//
//  WPPostViewModel.h
//  Wordpress
//
//  Created by Evgeniy Yurtaev on 09/01/15.
//  Copyright (c) 2015 Evgeniy Yurtaev. All rights reserved.
//

#import "WPViewModel.h"

@class RACSignal;

@interface WPPostViewModel : WPViewModel

@property (copy, nonatomic, readonly) NSString *HTMLString;

@property (strong, nonatomic, readonly) NSURL *baseURL;

@property (assign, nonatomic, readonly) NSInteger numberOfComments;

- (instancetype)initWithSiteID:(NSNumber *)siteID postID:(NSNumber *)postID;

@end
