//
//  WPPostsItemStateImp.m
//  Wordpress
//
//  Created by Evgeniy Yurtaev on 19/04/15.
//  Copyright (c) 2015 Evgeniy Yurtaev. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>

#import "WPPostsItemStateImp.h"
#import "WPPost.h"

#import "SDWebImageManager+RACExtension.h"
#import "NSString+RemovingHTMLElements.h"

@interface WPPostsItemState ()

@property (strong, nonatomic) WPPost *post;

@end

@implementation WPPostsItemState

- (instancetype)initWithPost:(WPPost *)post
{
    self = [super init];
    if (self) {
        self.post = post;
    }
    return self;
}

- (NSString *)title
{
    return [self.post.title wp_stringByRemovingHTMLElements];
}

- (NSString *)excerpt
{
    return [self.post.excerpt wp_stringByRemovingHTMLElements];
}

- (NSNumber *)numberOfComments
{
    return self.post.numberOfComments;
}

- (RACSignal *)loadImage
{
    return [[RACSignal
        defer:^RACSignal *{
            if (!self.post.featuredImageURL) return [RACSignal empty];

            return [[SDWebImageManager sharedManager] rac_downloadImageWithURL:self.post.featuredImageURL options:0];
        }]
        catchTo:[RACSignal empty]];
}

- (BOOL)isEqual:(WPPostsItemState *)object
{
    if (![object isKindOfClass:[self class]]) return NO;

    return [self.post isEqual:object.post];
}

@end
