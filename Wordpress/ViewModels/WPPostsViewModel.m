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

#import "WPRouter+Post.h"
#import "WPViewModel+Friend.h"

@interface WPPostsViewModel ()

@property (assign, nonatomic) BOOL nextPageExisted;
@property (assign, nonatomic) NSInteger numberOfObjets;

@property (strong, nonatomic) WPPaginator *paginator;
@property (strong, nonatomic) RACSignal *dataUpdated;

@end

@implementation WPPostsViewModel

- (instancetype)initWithPaginator:(WPPaginator *)paginator
{
    NSParameterAssert(paginator);
    
    self = [super init];
    if (self) {
        self.paginator = paginator;
        
        RACSubject *dataUpdated = [RACSubject subject];
        [[RACObserve(self.paginator, objects)
            skip:1]
            subscribeNext:^(id _) {
                [dataUpdated sendNext:[RACUnit defaultUnit]];
            }];
        self.dataUpdated = dataUpdated;
        
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

-  (WPPostsItemViewModel *)itemViewModelAtIndex:(NSInteger)index
{
    WPPost *post = self.paginator.objects[index];
    WPPostsItemViewModel *itemViewModel = [[WPPostsItemViewModel alloc] initWithPost:post];
    
    return itemViewModel;
}

- (RACSignal *)selectItemViewModelAtIndex:(NSInteger)index
{
    WPPost *post = self.paginator.objects[index];
    return [[WPRouter sharedInstance] presentPostScreenWithPost:post];
}

- (RACSignal *)prepareForUse
{
    return [[super prepareForUse]
        then:^RACSignal *{
            return [self reloadData];
        }];
}

@end
