//
//  WPPostViewController.h
//  Wordpress
//
//  Created by Evgeniy Yurtaev on 10/01/15.
//  Copyright (c) 2015 Evgeniy Yurtaev. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WPPostViewModel;

@interface WPPostViewController : UIViewController

- (instancetype)initWithViewModel:(WPPostViewModel *)viewModel;

@end
