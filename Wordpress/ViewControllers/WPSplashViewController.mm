//
//  WPSplashViewController.m
//  Wordpress
//
//  Created by Evgeniy Yurtaev on 01/01/15.
//  Copyright (c) 2015 Evgeniy Yurtaev. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ComponentKit/CKComponent.h>
#import <ComponentKit/CKLabelComponent.h>
#import <ComponentKit/CKStackLayoutComponent.h>
#import <ComponentKit/CKCenterLayoutComponent.h>
#import <ComponentKit/CKInsetComponent.h>
#import <ComponentKit/CKComponentHostingView.h>

#import "WPSplashViewController.h"
#import "WPSplashViewModel.h"
#import "WPSplashState.h"

#import "UIFont+Factory.h"
#import "UIActivityIndicatorView+Animated.h"

@interface WPSplashViewController () <CKComponentProvider>

@property (strong, nonatomic) id<WPSplashViewModel> viewModel;

@property (strong, nonatomic) CKComponentHostingView *componentHostingView;

@property (weak, nonatomic) UINavigationController *navigationControllerWithHiddenNavigationBar;

@end

@implementation WPSplashViewController

- (instancetype)initWithViewModel:(id<WPSplashViewModel>)viewModel
{
    NSParameterAssert(viewModel);
    self = [super init];
    if (self) {
        self.viewModel = viewModel;
    }
    return self;
}

- (void)loadView
{
    self.componentHostingView = [[CKComponentHostingView alloc] initWithComponentProvider:[self class] sizeRangeProvider:nil context:nil];
    self.componentHostingView.backgroundColor = [UIColor whiteColor];
    self.view = self.componentHostingView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    RAC(self.componentHostingView, model) = [self.viewModel state];
    [[self.viewModel fetchData] subscribeCompleted:^{}];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    self.navigationControllerWithHiddenNavigationBar = self.navigationController;
    [self.navigationControllerWithHiddenNavigationBar setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationControllerWithHiddenNavigationBar setNavigationBarHidden:NO animated:animated];
}

+ (CKComponent *)componentForModel:(id<WPSplashState>)model context:(id<NSObject>)context
{
    std::vector<CKStackLayoutComponentChild> children;

    if ([model loading]) {
        children.push_back({ [self throbberComponent] });
    }

    if ([[model errorMessage] length] > 0) {
        CKComponent *errorLabelComponent = [CKCenterLayoutComponent newWithCenteringOptions:CKCenterLayoutComponentCenteringX sizingOptions:0
            child:[CKLabelComponent newWithLabelAttributes:{
                [model errorMessage],
                nil,
                [UIFont wp_regularFontWithSize:14]
            } viewAttributes:{}]
        size:{}];
        children.push_back({errorLabelComponent});
    }

    return [CKInsetComponent
        newWithInsets:UIEdgeInsetsMake(15, 15, 15, 15)
        component:[CKStackLayoutComponent newWithView:{} size:{} style:{CKStackLayoutDirectionVertical, 15, CKStackLayoutJustifyContentEnd, CKStackLayoutAlignItemsEnd} children:children]];
}

+ (CKComponent *)throbberComponent
{
    CKComponent *throbberComponent = [CKComponent newWithView:{
        [UIActivityIndicatorView class],
        {
            { @selector(setActivityIndicatorViewStyle:), @(UIActivityIndicatorViewStyleGray) },
            { @selector(setAnimated:), @(YES) }
        }
    } size:{ 20, 20 }];

    return [CKCenterLayoutComponent newWithCenteringOptions:CKCenterLayoutComponentCenteringXY sizingOptions:0 child:throbberComponent size:{}];
}

@end
