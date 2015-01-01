//
//  WPSplashViewController.h
//  Wordpress
//
//  Created by Evgeniy Yurtaev on 01/01/15.
//  Copyright (c) 2015 Evgeniy Yurtaev. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WPSplashViewModel;

@interface WPSplashViewController : UIViewController

- (instancetype)initWithViewModel:(WPSplashViewModel *)viewModel;

@end
