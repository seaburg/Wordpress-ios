//
//  WPPostViewController.m
//  Wordpress
//
//  Created by Evgeniy Yurtaev on 10/01/15.
//  Copyright (c) 2015 Evgeniy Yurtaev. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ComponentKit/CKComponent.h>
#import <ComponentKit/CKCompositeComponent.h>
#import <ComponentKit/CKComponentHostingView.h>

#import "WPPostViewController.h"
#import "WPPostViewModel.h"
#import "WPPostState.h"

#import "UIWebView+Tuple.h"

@interface WPPostViewController () <CKComponentProvider>

@property (strong, nonatomic) id<WPPostViewModel> viewModel;

@property (strong, nonatomic) CKComponentHostingView *componentHostingView;

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation WPPostViewController

- (instancetype)initWithViewModel:(id<WPPostViewModel>)viewModel
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
    self.view = self.componentHostingView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.edgesForExtendedLayout = UIRectEdgeBottom;
    RAC(self.componentHostingView, model) = [[self.viewModel state]
        map:^id(id<WPPostState> value) {
            return RACTuplePack([value HTMLString], [value baseURL]);
        }];
}

+ (CKComponent *)componentForModel:(RACTuple *)model context:(id<NSObject>)context;
{
    return [CKCompositeComponent
        newWithComponent:
            [CKComponent
             newWithView:{
                 [UIWebView class],
                 {
                     {@selector(wp_loadWithHTMLStringAndBaseURLTuple:), model },
                 }
             } size:{}]];
}

@end
