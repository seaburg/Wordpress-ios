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
#import "WPClient.h"
#import "WPSite.h"

#import "WPRouter+Splash.h"

@interface AppDelegate ()

@property (strong, nonatomic) WPRouter *router;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    WPClient *client = [[WPClient alloc] initWithBaseURL:[NSURL URLWithString:WPAPIBaseURL]];
    WPSite *site = [[WPSite alloc] init];
    site.siteID = @(WPSiteID);
    client.currentSite = site;
    [WPClient setSharedInstance:client];

    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.router = [[WPRouter alloc] initWithWindow:self.window];
    [self.window makeKeyAndVisible];

    [[self.router presentSplashScreen] subscribeCompleted:^{}];
    
    return YES;
}

@end
