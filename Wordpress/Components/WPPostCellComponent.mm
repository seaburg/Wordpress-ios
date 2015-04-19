//
//  WPPostCellComponent.m
//  Wordpress
//
//  Created by Evgeniy Yurtaev on 19/04/15.
//  Copyright (c) 2015 Evgeniy Yurtaev. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ComponentKit/CKComponentScope.h>
#import <ComponentKit/CKInsetComponent.h>
#import <ComponentKit/CKStackLayoutComponent.h>
#import <ComponentKit/CKLabelComponent.h>
#import <ComponentKit/CKComponentSubclass.h>
#import <ComponentKit/CKComponentGestureActions.h>

#import "WPPostCellComponent.h"

#import "UIFont+Factory.h"
#import "SDWebImageManager+RACExtension.h"

@interface WPPostCellComponent ()

@property (copy, nonatomic) void(^tapHandler)(void);

@end

@implementation WPPostCellComponent

+ (instancetype)newWithPostsItemState:(id<WPPostsItemState>)state tapHandler:(void (^)())tapHandler
{
    CKComponentScope scope(self);
    UIImage *image = scope.state();

    WPPostCellComponent *component = [self
        newWithView:{
            [UIView class],
            {
                { CKComponentTapGestureAttribute(@selector(didTapOnView)) },
            },
        }
        component:
            [CKStackLayoutComponent
                newWithView:{}
                size:{}
                style:{
                    .direction = CKStackLayoutDirectionVertical,
                }
                children:{
                    {
                        .component = [CKInsetComponent
                            newWithInsets:UIEdgeInsetsMake(5, 15, 5, 15)
                            component:[self contentComponentWithPostsItemState:state image:image]],
                    },
                    {
                        [CKComponent
                            newWithView:{
                                [UIView class],
                                {
                                    { @selector(setBackgroundColor:), [UIColor colorWithWhite:0.87 alpha:1] },
                                }
                            }
                            size:{ .width = CKRelativeDimension::Percent(1), .height = 1}],
                    },
             }]

        ];
    component.tapHandler = tapHandler;

    if (!image) {
        [component rac_liftSelector:@checkselector(component, setThumbnailImage:) withSignalsFromArray:@[ [state loadImage] ]];
    }

    return component;
}

+ (CKCompositeComponent *)contentComponentWithPostsItemState:(id<WPPostsItemState>)state image:(UIImage *)image
{
    return [CKCompositeComponent
        newWithView:{}
        component:
            [CKStackLayoutComponent
                newWithView:{}
                size:{}
                style:{
                    .direction = CKStackLayoutDirectionVertical,
                    .spacing = 10,
                }
                children:{
                    {
                        .component = [CKStackLayoutComponent
                            newWithView:{}
                            size:{}
                            style:{
                                .direction = CKStackLayoutDirectionHorizontal,
                                .spacing = 5,
                            }
                                children:{
                                    {
                                        .component = image ? [CKComponent
                                            newWithView:{
                                                [UIImageView class],
                                                {
                                                    { @selector(setImage:), image },
                                                    { @selector(setContentMode:), @(UIViewContentModeScaleAspectFill) },
                                                    { @selector(setClipsToBounds:), @YES },
                                                }
                                            } size:{ 64, 64 }] : nil,
                                    },
                                    {
                                        .component = [CKStackLayoutComponent
                                            newWithView:{}
                                            size:{}
                                            style:{
                                                .direction = CKStackLayoutDirectionVertical,
                                                .spacing = 5,
                                            }
                                            children:{
                                                {
                                                    .component = [CKLabelComponent
                                                        newWithLabelAttributes:{
                                                            .string = [state title],
                                                            .font = [UIFont wp_boldFontWithSize:16],
                                                        } viewAttributes:{
                                                            { @selector(setUserInteractionEnabled:), @NO },
                                                        }],
                                                },
                                                {
                                                    .component = [CKLabelComponent
                                                        newWithLabelAttributes:{
                                                            .string = [state excerpt],
                                                            .font = [UIFont wp_regularFontWithSize:14],
                                                        } viewAttributes:{
                                                            { @selector(setUserInteractionEnabled:), @NO },
                                                        }]
                                                },
                                        }]
                                    }
                        }]
                    },
                    {
                        .component = [CKStackLayoutComponent
                            newWithView:{}
                            size:{}
                            style:{
                                .direction = CKStackLayoutDirectionHorizontal,
                                .spacing = 4,
                            }
                            children:{
                                {
                                    .component = [CKComponent
                                        newWithView:{
                                            [UIImageView class],
                                            {
                                                { @selector(setImage:), [UIImage imageNamed:@"comment_small"] },
                                                { @selector(setTintColor:), [UIColor colorWithWhite:0.46 alpha:1] },
                                            }
                                        } size:{ 22, 22 }]
                                },
                                {
                                    .component = [CKLabelComponent
                                        newWithLabelAttributes:{
                                            .string = [[state numberOfComments] stringValue],
                                            .font = [UIFont wp_regularFontWithSize:12],
                                            .color = [UIColor colorWithWhite:0.46 alpha:1],
                                        } viewAttributes:{
                                            { @selector(setUserInteractionEnabled:), @NO },
                                        }]
                                }
                            }]
                    },
                }]];
}

- (void)setThumbnailImage:(UIImage *)image
{
    [self updateState:^id(id) {
        return image;
    }];
}

- (void)didTapOnView
{
    if (self.tapHandler) {
        self.tapHandler();
    }
}

@end
