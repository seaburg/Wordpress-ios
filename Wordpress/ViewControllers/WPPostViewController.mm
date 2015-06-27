//
//  WPPostViewController.m
//  Wordpress
//
//  Created by Evgeniy Yurtaev on 10/01/15.
//  Copyright (c) 2015 Evgeniy Yurtaev. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ComponentKit/ComponentKit.h>

#import "WPPostViewController.h"
#import "WPPostViewModel.h"
#import "WPPostState.h"
#import "WPPostHeaderComponent.h"

#import "UIWebView+Tuple.h"

@interface WPPostViewController () <CKComponentProvider, CKComponentSizeRangeProviding>

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
    self.componentHostingView = [[CKComponentHostingView alloc] initWithComponentProvider:[self class] sizeRangeProvider:[self class] context:nil];
    self.view = self.componentHostingView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.edgesForExtendedLayout = UIRectEdgeBottom;
    RAC(self.componentHostingView, model) = [self.viewModel state];
}

#pragma mark - CKComponentProvider

+ (CKComponent *)componentForModel:(id<WPPostState>)model context:(id<NSObject>)context;
{
    return [CKCompositeComponent newWithComponent:
        [CKStackLayoutComponent newWithView:{}
            size:{}
            style:{
                .direction = CKStackLayoutDirectionVertical,
                .alignItems = CKStackLayoutAlignItemsStretch
            }
            children:{
                {
                    .component = [CKCompositeComponent
                        newWithView:{
                            [UIView class],
                            {
                                {@selector(setBackgroundColor:), [UIColor whiteColor]}
                            }
                        }
                        component:[WPPostHeaderComponent newWithPostState:model
                            size:{
                                .width = CKRelativeDimension::Percent(1)
                            }]]
                },
                {
                    .component = [CKComponent
                        newWithView:{
                            [UIView class],
                            {
                                {@selector(setBackgroundColor:), [UIColor colorWithWhite:0.8 alpha:1]}
                            }
                        } size:{
                            .width = CKRelativeDimension::Percent(1),
                            .height = 1,
                        }]
                },
                {
                    .component = [CKComponent
                        newWithView:{
                            [UIWebView class],
                            {
                                {@selector(wp_loadWithHTMLStringAndBaseURLTuple:), RACTuplePack([model HTMLString], [model baseURL]) },
                            }
                        }
                        size:{
                            .width = CKRelativeDimension::Percent(1) 
                        }],
                    .flexGrow = YES,
                    .flexShrink = YES,
                }
            }]];
}

#pragma mark - CKComponentSizeRangeProviding

- (CKSizeRange)sizeRangeForBoundingSize:(CGSize)size
{
    CGSize viewSize = self.view.frame.size;
    return { viewSize, viewSize };
}

@end
