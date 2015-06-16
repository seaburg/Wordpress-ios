//
//  WPPostsViewModelImp.h
//  Wordpress
//
//  Created by Evgeniy Yurtaev on 19/04/15.
//  Copyright (c) 2015 Evgeniy Yurtaev. All rights reserved.
//

#import "WPViewModel.h"
#import "WPPostsViewModel.h"

@class WPSite;

@interface WPPostsViewModel : NSObject <WPViewModel, WPPostsViewModel>

- (instancetype)initWithSite:(WPSite *)site NS_DESIGNATED_INITIALIZER;

@end
