//
//  WPPostsViewController.h
//  Wordpress
//
//  Created by Evgeniy Yurtaev on 06/01/15.
//  Copyright (c) 2015 Evgeniy Yurtaev. All rights reserved.
//

#import "WPPostsViewModel.h"

@interface WPPostsViewController : UICollectionViewController

- (instancetype)initWithPostsViewModel:(id<WPPostsViewModel>)viewModel NS_DESIGNATED_INITIALIZER;

@end
