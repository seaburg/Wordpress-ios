//
//  WPClient.h
//  Wordpress
//
//  Created by Evgeniy Yurtaev on 01/01/15.
//  Copyright (c) 2015 Evgeniy Yurtaev. All rights reserved.
//

#import "WPSessionManager.h"

@class WPSite;

@interface WPClient : WPSessionManager

@property (strong, nonatomic) WPSite *currentSite;

@end
