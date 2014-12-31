//
//  SDWebImageManager+RACExtension.h
//  Wordpress
//
//  Created by Evgeniy Yurtaev on 31/12/14.
//  Copyright (c) 2014 Evgeniy Yurtaev. All rights reserved.
//

#import "SDWebImageManager.h"

@class RACSignal;
@interface SDWebImageManager (RACExtension)

// rac_downloadImageWithURL:options: : -> RACSignal UIImage
- (RACSignal *)rac_downloadImageWithURL:(NSURL *)url options:(SDWebImageOptions)options;

// rac_downloadImageExtendedWithURL:options: : -> RACSignal (UIImage, SDImageCacheType)
- (RACSignal *)rac_downloadImageExtendedWithURL:(NSURL *)url options:(SDWebImageOptions)options;

@end
