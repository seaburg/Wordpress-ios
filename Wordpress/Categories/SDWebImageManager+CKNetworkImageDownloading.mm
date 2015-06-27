//
//  SDWebImageManager+CKNetworkImageDownloading.m
//  Wordpress
//
//  Created by Evgeniy Yurtaev on 27/06/15.
//  Copyright (c) 2015 Evgeniy Yurtaev. All rights reserved.
//

#import "SDWebImageManager+CKNetworkImageDownloading.h"

@implementation SDWebImageManager (CKNetworkImageDownloading)

- (id)downloadImageWithURL:(NSURL *)URL
                 scenePath:(id)scenePath
                    caller:(id)caller
             callbackQueue:(dispatch_queue_t)callbackQueue
     downloadProgressBlock:(void (^)(CGFloat progress))downloadProgressBlock
                completion:(void (^)(CGImageRef image, NSError *error))completion;
{
    return [self downloadImageWithURL:URL
        options:0
        progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            if (downloadProgressBlock) {
                dispatch_async(callbackQueue, ^{
                    CGFloat progress = (CGFloat)receivedSize / expectedSize;
                    downloadProgressBlock(progress);
                });
            }

        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            if (completion) {
                dispatch_async(callbackQueue, ^{
                    completion([image CGImage], error);
                });
            }
        }];
}
- (void)cancelImageDownload:(id<SDWebImageOperation>)download
{
    [download cancel];
}

@end
