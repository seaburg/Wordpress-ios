//
//  WPPostsViewController.h
//  Wordpress
//
//  Created by Evgeniy Yurtaev on 06/01/15.
//  Copyright (c) 2015 Evgeniy Yurtaev. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WPPostsViewModel;

@interface WPPostsViewController : UIViewController

- (instancetype)initWithPostsViewModel:(WPPostsViewModel *)viewModel;

@end
