//
//  WPUser.h
//  Wordpress
//
//  Created by Evgeniy Yurtaev on 02/01/15.
//  Copyright (c) 2015 Evgeniy Yurtaev. All rights reserved.
//

#import "WPModel.h"

@interface WPUser : WPModel

// numeric user ID
@property (strong, nonatomic) NSNumber *userID;

// the name to display for a user
@property (copy, nonatomic) NSString *displayName;

// login name of a user
@property (copy, nonatomic) NSString *name;

// nice name of a user
@property (copy, nonatomic) NSString *niceName;

// email address
@property (copy, nonatomic) NSString *email;

// ID of a user's primary blog
@property (strong, nonatomic) NSNumber *primaryBlog;

// user language setting
@property (copy, nonatomic) NSString *language;

// gravatar image URL
@property (strong, nonatomic) NSURL *avatarImageURL;

// gravatar profile URL
@property (strong, nonatomic) NSURL *profileImageURL;

@end
