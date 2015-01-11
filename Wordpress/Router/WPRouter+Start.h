//
//  WPRouter+Start.h
//  Wordpress
//
//  Created by Evgeniy Yurtaev on 11/01/15.
//  Copyright (c) 2015 Evgeniy Yurtaev. All rights reserved.
//

#import "WPRouter.h"

@class WPSite;

@interface WPRouter (Start)

// presentStartScreenWithSite: : -> RACSignal _
- (RACSignal *)presentStartScreenWithSite:(WPSite *)site;

@end
