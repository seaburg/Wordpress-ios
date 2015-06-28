//
//  WPPostCellComponent.m
//  Wordpress
//
//  Created by Evgeniy Yurtaev on 19/04/15.
//  Copyright (c) 2015 Evgeniy Yurtaev. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ComponentKit/ComponentKit.h>

#import "WPPostCellComponent.h"

#import "UIFont+Factory.h"
#import "SDWebImageManager+CKNetworkImageDownloading.h"

@implementation WPPostCellComponent

+ (instancetype)newWithPostsItemState:(id<WPPostsItemState>)state
{
    return [super newWithComponent:[CKStackLayoutComponent
        newWithView:{}
        size:{}
        style:{
            .direction = CKStackLayoutDirectionVertical,
            .alignItems = CKStackLayoutAlignItemsStretch,
        }
        children:{
            {
                .component = [CKStackLayoutComponent
                    newWithView:{}
                    size:{
                        .width = CKRelativeDimension::Percent(1)
                    }
                    style:{
                        .direction = CKStackLayoutDirectionHorizontal,
                        .alignItems = CKStackLayoutAlignItemsStretch,
                        .spacing = 5
                    }
                    children:{
                        {
                            .component =
                                [state imageURL] ? [CKStackLayoutComponent
                                    newWithView:{}
                                    size:{
                                        .width = 64
                                    }
                                    style:{
                                        .direction = CKStackLayoutDirectionVertical,
                                        .alignItems = CKStackLayoutAlignItemsStretch
                                    }
                                    children:{
                                        {
                                            .component = [CKNetworkImageComponent newWithURL:[state imageURL]
                                                imageDownloader:[SDWebImageManager sharedManager]
                                                scenePath:nil
                                                size:{
                                                    .width = 64,
                                                    .height = 64,
                                                }
                                                options:{}
                                                attributes:{
                                                    { @selector(setClipsToBounds:), @YES },
                                                    { @selector(setContentMode:), @(UIViewContentModeScaleAspectFill) }
                                                }]
                                        },
                                        {
                                            .component = [CKComponent newWithView:{} size:{}],
                                            .flexGrow = YES,
                                            .flexShrink = YES
                                        }
                                    }]
                                :
                                    nil
                        },
                        {
                            .component = [CKStackLayoutComponent
                                newWithView:{[UIView class]}
                                size:{
                                }
                                style:{
                                    .direction = CKStackLayoutDirectionVertical
                                }
                                children:{
                                    {
                                        .component = [CKLabelComponent
                                            newWithLabelAttributes:{
                                                .string = [state title],
                                                .font = [UIFont wp_boldFontWithSize:14],
                                                .maximumNumberOfLines = 0
                                            } viewAttributes:{
                                                { @selector(setUserInteractionEnabled:), @NO }
                                            }]
                                    },
                                    {
                                        .component = [CKLabelComponent
                                            newWithLabelAttributes:{
                                                .string = [state excerpt],
                                                .font = [UIFont wp_regularFontWithSize:14],
                                                .maximumNumberOfLines = 0
                                            } viewAttributes:{
                                                { @selector(setUserInteractionEnabled:), @NO }
                                            }]
                                    },
                                    {
                                        .component = [CKComponent
                                            newWithView:{}
                                            size:{}],
                                        .flexGrow = YES,
                                        .flexShrink = YES
                                    }
                                }],
                            .flexShrink = YES
                        }
                    }]
            },
            {
                .component = [CKStackLayoutComponent
                    newWithView:{}
                    size:{
                        .width = CKRelativeDimension::Percent(1)
                    }
                    style:{
                        .direction = CKStackLayoutDirectionHorizontal,
                        .alignItems = CKStackLayoutAlignItemsStart,
                        .spacing = 3
                    }
                    children:{
                        {
                            .component = [CKLabelComponent
                                newWithLabelAttributes:{
                                    .string = [([state numberOfComments] ?: @0) stringValue],
                                    .font = [UIFont wp_regularFontWithSize:14]
                                }
                                viewAttributes:{
                                    { @selector(setUserInteractionEnabled:), @NO }
                                }]
                        },
                        {
                            .component = [CKImageComponent newWithImage:[UIImage imageNamed:@"comment_small"]]
                        }
                    }]
            }
        }]];
}


@end
