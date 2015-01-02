//
//  WPPost.h
//  Wordpress
//
//  Created by Evgeniy Yurtaev on 02/01/15.
//  Copyright (c) 2015 Evgeniy Yurtaev. All rights reserved.
//

#import "WPModel.h"

@class WPUser;

typedef NS_ENUM(NSInteger, WPPostStatus) {
    WPPostStatusUnknown,
    WPPostStatusPublish,
    WPPostStatusDraft,
    WPPostStatusPending,
    WPPostStatusPrivate,
    WPPostStatusFuture,
    WPPostStatusTrash,
    WPPostStatusAutoDraft,
};

typedef NS_ENUM(NSInteger, WPPostFormat) {
    WPPostFormatUnknown,
    WPPostFormatStandard,
    WPPostFormatAside,
    WPPostFormatChat,
    WPPostFormatGallery,
    WPPostFormatLink,
    WPPostFormatImage,
    WPPostFormatQuote,
    WPPostFormatStatus,
    WPPostFormatVideo,
    WPPostFormatAudio,
};

@interface WPPost : WPModel

// post ID
@property (strong, nonatomic) NSNumber *postID;

// site ID
@property (strong, nonatomic) NSNumber *siteID;

// author
@property (strong, nonatomic) WPUser *author;

// creation time
@property (strong, nonatomic) NSDate *creationDate;

// most recent update time
@property (strong, nonatomic) NSDate *modifiedDate;

// title
@property (strong, nonatomic) NSString *title;

// full permalink URL.
@property (strong, nonatomic) NSURL *URL;

// short URL
@property (strong, nonatomic) NSURL *shortURL;

// html content
@property (strong, nonatomic) NSString *content;

// excerpt
@property (copy, nonatomic) NSString *excerpt;

// name (slug) for the post, used in URLs
@property (copy, nonatomic) NSString *slug;

@property (assign, nonatomic) WPPostStatus status;

// open for comments?
@property (strong, nonatomic) NSNumber *commentsOpened;

// open for pingbacks, trackbacks?
@property (strong, nonatomic) NSNumber *pingsOpened;

// open to likes?
@property (strong, nonatomic) NSNumber *likesEnabled;

// number of comments
@property (strong, nonatomic) NSNumber *numberOfComments;

// number of likes
@property (strong, nonatomic) NSNumber *numberOfLikes;

// does the current user like this post?
@property (strong, nonatomic) NSNumber *liked;

// did the current user reblog this post?
@property (strong, nonatomic) NSNumber *reblogged;

// is the current user following this blog?
@property (strong, nonatomic) NSNumber *following;

// the URL to the featured image for this post if it has one.
@property (strong, nonatomic) NSURL *featuredImageURL;

// the attachment object for the featured image if it has one.
@property (strong, nonatomic) NSURL *thumbnailURL;

@property (assign, nonatomic) WPPostFormat format;


@end
