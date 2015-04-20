//
//  WPPostViewController.h
//  Wordpress
//
//  Created by Evgeniy Yurtaev on 10/01/15.
//  Copyright (c) 2015 Evgeniy Yurtaev. All rights reserved.
//

#import "WPPostViewModel.h"

@interface WPPostViewController : UIViewController

- (instancetype)initWithViewModel:(id<WPPostViewModel>)viewModel;

@end
