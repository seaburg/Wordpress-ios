//
//  WPSite.h
//  Wordpress
//
//  Created by Evgeniy Yurtaev on 01/01/15.
//  Copyright (c) 2015 Evgeniy Yurtaev. All rights reserved.
//

#import "WPModel.h"

@interface WPSite : WPModel

// site ID
@property (strong, nonatomic) NSNumber *siteID;

// title of site
@property (copy, nonatomic) NSString *name;

// tagline or description of site
@property (copy, nonatomic) NSString *descriptionOfSite;

// full URL to the site
@property (copy, nonatomic) NSURL *URL;

// The number of posts the site has
@property (strong, nonatomic) NSNumber *postsCount;

// The number of subscribers the site has
@property (strong, nonatomic) NSNumber *subscribersCount;

// icon of site
@property (strong, nonatomic) NSURL *iconURL;

// small icon of site
@property (strong, nonatomic) NSURL *smallIconURL;

// if this site is visible in the user's site list
@property (strong, nonatomic) NSNumber *visible;

// if the site is a private site or not
@property (strong, nonatomic) NSNumber *isPrivate;

// if the current user is subscribed to this site in the reader
@property (strong, nonatomic) NSNumber *isFollowing;

@end
