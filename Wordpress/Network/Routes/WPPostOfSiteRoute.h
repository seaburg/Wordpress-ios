//
//  WPPostOfSiteRoute.h
//  Wordpress
//
//  Created by Evgeniy Yurtaev on 10/01/15.
//  Copyright (c) 2015 Evgeniy Yurtaev. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface WPPostOfSiteRoute : MTLModel<MTLJSONSerializing>

@property (strong, nonatomic) NSNumber *siteID;

@property (strong, nonatomic) NSNumber *postID;

@end
