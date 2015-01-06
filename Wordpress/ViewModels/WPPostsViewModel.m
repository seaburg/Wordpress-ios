//
//  WPPostsViewModel.m
//  Wordpress
//
//  Created by Evgeniy Yurtaev on 04/01/15.
//  Copyright (c) 2015 Evgeniy Yurtaev. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>

#import "WPPostsViewModel.h"
#import "WPPostsItemViewModel.h"
#import "WPPaginator.h"

@interface WPPostsViewModel ()

@property (assign, nonatomic) BOOL nextPageExisted;
@property (assign, nonatomic) NSInteger numberOfObjets;

@property (strong, nonatomic) WPPaginator *paginator;

@end

@implementation WPPostsViewModel

- (instancetype)initWithPaginator:(WPPaginator *)paginator
{
    NSParameterAssert(paginator);
    
    self = [super init];
    if (self) {
        self.paginator = paginator;
        
        RAC(self, nextPageExisted) = RACObserve(self.paginator, nextPageExisted);
        
        RAC(self, numberOfObjets) = [[RACObserve(self.paginator, objects)
            map:^id(NSArray *objects) {
                return @([objects count]);
            }]
            distinctUntilChanged];
    }
    return self;
}

- (RACSignal *)reloadData
{
    return [self.paginator reloadData];
}

- (RACSignal *)loadNextPage
{
    return [self.paginator loadNextPage];
}

- (RACSignal *)dataUpdated
{
    return [[[[RACObserve(self, numberOfObjets) skip:1] distinctUntilChanged]
        merge:[RACObserve(self.paginator, objects) skip:1]]
        mapReplace:[RACUnit defaultUnit]];
}

-  (WPPostsItemViewModel *)itemViewModelAtIndex:(NSInteger)index
{
    WPPost *post = self.paginator.objects[index];
    WPPostsItemViewModel *itemViewModel = [[WPPostsItemViewModel alloc] initWithPost:post];
    
    return itemViewModel;
}

@end
