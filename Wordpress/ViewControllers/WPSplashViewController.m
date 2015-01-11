//
//  WPSplashViewController.m
//  Wordpress
//
//  Created by Evgeniy Yurtaev on 01/01/15.
//  Copyright (c) 2015 Evgeniy Yurtaev. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>

#import "WPSplashViewController.h"
#import "WPSplashViewModel.h"

@interface WPSplashViewController ()

@property (strong, nonatomic) WPSplashViewModel *viewModel;

@property (assign, nonatomic) BOOL viewFirstAppeared;
@property (weak, nonatomic) IBOutlet UILabel *errorMessageLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;

@property (weak, nonatomic) UINavigationController *navigationControllerWithHiddenNavigationBar;

@end

@implementation WPSplashViewController

- (instancetype)initWithViewModel:(WPSplashViewModel *)viewModel
{
    NSParameterAssert(viewModel);
    self = [super init];
    if (self) {
        self.viewModel = viewModel;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    RAC(self.errorMessageLabel, text) = RACObserve(self.viewModel, errorMessage);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationControllerWithHiddenNavigationBar = self.navigationController;
    [self.navigationControllerWithHiddenNavigationBar setNavigationBarHidden:YES animated:NO];
    
    if (!self.viewFirstAppeared) {
        @weakify(self);
        [[[[self.viewModel fetchData]
            initially:^{
                @strongify(self);
                [self.activityIndicatorView startAnimating];
            }]
            finally:^{
                @strongify(self);
                [self.activityIndicatorView stopAnimating];
            }]
            replay];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.viewFirstAppeared = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationControllerWithHiddenNavigationBar setNavigationBarHidden:NO animated:animated];
}

@end
