//
//  WPPostHeaderComponent.m
//  Wordpress
//
//  Created by Evgeniy Yurtaev on 27/06/15.
//  Copyright (c) 2015 Evgeniy Yurtaev. All rights reserved.
//

#import "WPPostHeaderComponent.h"

#import "SDWebImageManager+CKNetworkImageDownloading.h"
#import "UIFont+Factory.h"

@implementation WPPostHeaderComponent

+ (instancetype)newWithPostState:(id<WPPostState>)postState size:(const CKComponentSize &)size
{
    return [super newWithComponent:
        [CKInsetComponent
         newWithInsets:UIEdgeInsetsMake(5, 5, 5, 5)
         component:[CKStackLayoutComponent newWithView:{}
            size:size
            style:{
                .direction = CKStackLayoutDirectionHorizontal,
                .alignItems = CKStackLayoutAlignItemsStretch,
                .spacing = 5
            }
            children:{
                {
                    .component = [postState authorAvatarURL] ?
                        [CKNetworkImageComponent
                         newWithURL:[postState authorAvatarURL]
                         imageDownloader:[SDWebImageManager sharedManager]
                         scenePath:nil
                         size:{}
                         options:{}
                         attributes:{
                             { @selector(setContentMode:), @(UIViewContentModeScaleAspectFill) },
                             { @selector(setClipsToBounds:), @(YES) },
                         }]
                    :
                        nil
                },
                {
                    .component = ([[postState authorName] length] > 0) ?
                        [CKTextComponent
                         newWithTextAttributes:{
                             .attributedString = [[NSAttributedString alloc] initWithString:[postState authorName] attributes:@{ NSFontAttributeName: [UIFont wp_regularFontWithSize:16] }]
                         }
                         viewAttributes:{}
                         accessibilityContext:{}]
                    :
                        nil
                },
                {
                    .component = [CKComponent newWithView:{} size:{}],
                    .flexGrow = YES,
                    .flexShrink = YES,
                },
                {
                    .component = [CKTextComponent
                        newWithTextAttributes:{
                            .attributedString = [[NSAttributedString alloc] initWithString:[ [postState numberOfComments]?: @0 stringValue] attributes:@{ NSFontAttributeName: [UIFont wp_regularFontWithSize:16] }]
                        }
                        viewAttributes:{}
                        accessibilityContext:{}]
                },
                {
                    .component = [CKImageComponent newWithImage:[UIImage imageNamed:@"comment_small"]]
                }
            }]]];
}

@end
