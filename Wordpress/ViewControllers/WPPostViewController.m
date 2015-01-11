//
//  WPPostViewController.m
//  Wordpress
//
//  Created by Evgeniy Yurtaev on 10/01/15.
//  Copyright (c) 2015 Evgeniy Yurtaev. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>

#import "WPPostViewController.h"
#import "WPPostViewModel.h"

@interface WPPostViewController ()

@property (strong, nonatomic) WPPostViewModel *viewModel;

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation WPPostViewController

- (instancetype)initWithViewModel:(WPPostViewModel *)viewModel
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
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.webView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.topLayoutGuide
                                                          attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    
    RACSignal *webViewContentSignal = [[RACObserve(self.viewModel, HTMLString) ignore:nil]
        combineLatestWith:[RACObserve(self.viewModel, baseURL) ignore:nil]];
    [self.webView rac_liftSelector:@checkselector(self.webView, loadHTMLString:,baseURL:) withSignalOfArguments:webViewContentSignal];
}

@end
