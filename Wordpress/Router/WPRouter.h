//
//  WPRouter.h
//  Wordpress
//
//  Created by Evgeniy Yurtaev on 31/12/14.
//  Copyright (c) 2014 Evgeniy Yurtaev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WPRouter : NSObject

+ (instancetype)sharedInstance;
+ (void)setSharedInstance:(WPRouter *)instance;

- (instancetype)initWithWindow:(UIWindow *)window;

@end
