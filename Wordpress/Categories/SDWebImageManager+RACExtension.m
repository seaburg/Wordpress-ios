//
//  SDWebImageManager+RACExtension.m
//  Wordpress
//
//  Created by Evgeniy Yurtaev on 31/12/14.
//  Copyright (c) 2014 Evgeniy Yurtaev. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>

#import "SDWebImageManager+RACExtension.h"

@implementation SDWebImageManager (RACExtension)

- (RACSignal *)rac_downloadImageWithURL:(NSURL *)url options:(SDWebImageOptions)options
{
    return [[self rac_downloadImageExtendedWithURL:url options:options]
        reduceEach:^id(UIImage *image, id _){
            return image;
        }];
}

- (RACSignal *)rac_downloadImageExtendedWithURL:(NSURL *)url options:(SDWebImageOptions)options
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        id<SDWebImageOperation> operation = [self downloadImageWithURL:url options:options progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            if (!error) {
                RACTuple *value = RACTuplePack(image, @(cacheType));
                [subscriber sendNext:value];
                
                if (finished) {
                    [subscriber sendCompleted];
                }
            } else {
                if (image) {
                    RACTuple *value = RACTuplePack(image, @(cacheType));
                    [subscriber sendNext:value];
                }
                [subscriber sendError:error];
            }
        }];
        
        return [RACDisposable disposableWithBlock:^{
            [operation cancel];
        }];
    }];
}

@end
