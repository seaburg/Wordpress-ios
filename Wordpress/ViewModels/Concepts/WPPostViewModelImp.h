//
//  WPPostViewModelImp.h
//  Wordpress
//
//  Created by Evgeniy Yurtaev on 20/04/15.
//  Copyright (c) 2015 Evgeniy Yurtaev. All rights reserved.
//

#import "WPViewModel.h"
#import "WPPostViewModel.h"

@class WPPost;

@interface WPPostViewModel : WPViewModel <WPPostViewModel>

- (instancetype)initWithPost:(WPPost *)post NS_DESIGNATED_INITIALIZER;

@end
