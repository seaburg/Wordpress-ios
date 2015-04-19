//
//  UIScrollView+RACCommand.h
//  Wordpress
//
//  Created by Evgeniy Yurtaev on 02.09.14.
//  Copyright (c) 2014 Evgeniy Yurtaev. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>

@interface UIScrollView (RACCommand_PullToRefresh)

@property (nonatomic, strong) RACCommand *rac_pullToRefreshCommand;

@end

@interface UIScrollView (RACCommand_InfinityScroll)

@property (nonatomic, strong) RACCommand *rac_infinityScrollCommand;

@end
