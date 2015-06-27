//
//  WPPostStateImp.m
//  Wordpress
//
//  Created by Evgeniy Yurtaev on 20/04/15.
//  Copyright (c) 2015 Evgeniy Yurtaev. All rights reserved.
//

#import "WPPostStateImp.h"
#import "WPPost.h"
#import "WPUser.h"

static NSString *const WPHTMLPageFormat = @"<html><head><style>*{max-width: 100%%};</style></head><body><h2>%@</h2><h4>%@</h4>%@<script>elements = document.getElementsByTagName('*')\nfor(i = 0;i < elements.length; i++) {\nelements[i].removeAttribute('height')\n}</script></body></html>";


@interface WPPostState ()

@property (strong, nonatomic) WPPost *post;

@end

@implementation WPPostState

+ (instancetype)emptyState
{
    WPPostState *state = [[self alloc] init];
    return state;
}

- (instancetype)stateBySettingPost:(WPPost *)post
{
    if (self.post == post || [self.post isEqual:post]) return self;

    WPPostState *nextState = [self copy];
    nextState.post = post;

    return nextState;
}

#pragma mark - WPPostState

- (NSString *)HTMLString
{
    if ([self.post.content length] < 1) return nil;

    NSString *HTMLStirng = [NSString stringWithFormat:WPHTMLPageFormat, self.post.title ?: @"", self.post.author.name ?: @"", self.post.content];

    return HTMLStirng;
}

- (NSURL *)baseURL
{
    return self.post.URL;
}

- (NSNumber *)numberOfComments
{
    return self.post.numberOfComments;
}

- (NSString *)authorName
{
    return self.post.author.niceName;
}

- (NSURL *)authorAvatarURL
{
    return self.post.author.avatarImageURL;
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    WPPostState *copyObject = [[[self class] alloc] init];
    copyObject.post = self.post;

    return copyObject;
}

@end
