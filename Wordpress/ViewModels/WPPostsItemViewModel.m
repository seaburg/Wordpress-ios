//
//  WPPostsItemViewModel.m
//  Wordpress
//
//  Created by Evgeniy Yurtaev on 02/01/15.
//  Copyright (c) 2015 Evgeniy Yurtaev. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>

#import "WPPostsItemViewModel.h"
#import "WPPost.h"

#import "SDWebImageManager+RACExtension.h"
#import "NSString+RemovingHTMLElements.h"

@interface WPPostsItemViewModel ()

@property (strong, nonatomic) WPPost *post;

@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *excerpt;
@property (assign, nonatomic) NSInteger numberOfComments;

@end

@implementation WPPostsItemViewModel

- (instancetype)initWithPost:(WPPost *)post
{
    NSParameterAssert(post);
    
    self = [super init];
    if (self) {
        self.post = post;
        
        RAC(self, title) = [RACObserve(self.post, title)
            map:^id(NSString *title) {
                return [title wp_stringByRemovingHTMLElements];
            }];
        
        RAC(self, excerpt) = [RACObserve(self.post, excerpt)
            map:^id(NSString *excerpt) {
                return [excerpt wp_stringByRemovingHTMLElements];
            }];
        
        RAC(self, numberOfComments) = RACObserve(self.post, numberOfComments);
    }
    return self;
}

- (RACSignal *)image
{
    NSString *const placeholderImageName = @"post_placeholder";
    
    return [[RACObserve(self.post, featuredImageURL)
        flattenMap:^RACStream *(NSURL *imageURL) {
            if (imageURL) {
                return [[SDWebImageManager sharedManager] rac_downloadImageWithURL:imageURL options:0];
            } else {
                return [RACSignal return:[UIImage imageNamed:placeholderImageName]];
            }
        }]
        startWith:[UIImage imageNamed:placeholderImageName]];
}

@end
