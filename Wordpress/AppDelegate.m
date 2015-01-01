//
//  AppDelegate.m
//  Wordpress
//
//  Created by Evgeniy Yurtaev on 30/12/14.
//  Copyright (c) 2014 Evgeniy Yurtaev. All rights reserved.
//

#import <libextobjc/extobjc.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

#import "AppDelegate.h"
#import "WPNavigationController.h"
#import "WPDefines.h"
#import "WPRouter.h"
#import "WPClient.h"
#import "WPSite.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    WPClient *client = [[WPClient alloc] initWithBaseURL:[NSURL URLWithString:WPAPIBaseURL]];
    WPSite *site = [[WPSite alloc] init];
    site.siteID = @(WPSiteID);
    client.currentSite = site;
    [WPClient setSharedInstance:client];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    WPRouter *router = [[WPRouter alloc] initWithWindow:self.window];
    [WPRouter setSharedInstance:router];
    
    [self.window makeKeyAndVisible];
    [[[WPRouter sharedInstance] presentRootScreen] replay];
    
    return YES;
}

@end
