//
//  WPPostState.h
//  Wordpress
//
//  Created by Evgeniy Yurtaev on 20/04/15.
//  Copyright (c) 2015 Evgeniy Yurtaev. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WPPostState <NSObject>

- (NSString *)HTMLString;

- (NSURL *)baseURL;

- (NSNumber *)numberOfComments;

- (NSString *)authorName;

- (NSURL *)authorAvatarURL;

@end
