//
//  WPPost.m
//  Wordpress
//
//  Created by Evgeniy Yurtaev on 02/01/15.
//  Copyright (c) 2015 Evgeniy Yurtaev. All rights reserved.
//

#import "WPPost.h"
#import "WPUser.h"

#import "NSValueTransformer+Factory.h"

@implementation WPPost

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSMutableDictionary *keyPaths = [NSMutableDictionary dictionaryWithDictionary:[super JSONKeyPathsByPropertyKey]];
    
    [keyPaths addEntriesFromDictionary:@{
        @keypath([WPPost new], postID): @"ID",
        @keypath([WPPost new], siteID): @"site_ID",
        @keypath([WPPost new], author): @"author",
        @keypath([WPPost new], creationDate): @"date",
        @keypath([WPPost new], modifiedDate): @"modified",
        @keypath([WPPost new], title): @"title",
        @keypath([WPPost new], URL): @"URL",
        @keypath([WPPost new], shortURL): @"short_URL",
        @keypath([WPPost new], content): @"content",
        @keypath([WPPost new], excerpt): @"excerpt",
        @keypath([WPPost new], slug): @"slug",
        @keypath([WPPost new], status): @"status",
        @keypath([WPPost new], commentsOpened): @"comments_open",
        @keypath([WPPost new], pingsOpened): @"pings_open",
        @keypath([WPPost new], likesEnabled): @"likes_enabled",
        @keypath([WPPost new], numberOfComments): @"comment_count",
        @keypath([WPPost new], numberOfLikes): @"like_count",
        @keypath([WPPost new], liked): @"i_like",
        @keypath([WPPost new], reblogged): @"is_reblogged",
        @keypath([WPPost new], following): @"is_following",
        @keypath([WPPost new], featuredImageURL): @"featured_image",
        @keypath([WPPost new], thumbnailURL): @"post_thumbnail.URL",
        @keypath([WPPost new], format): @"format",
    }];
    
    return [keyPaths copy];
}

+ (NSValueTransformer *)authorJSONTransformer
{
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^id(NSDictionary *value) {
        if (!value) {
            return nil;
        }
        NSError *error;
        WPUser *author = [MTLJSONAdapter modelOfClass:[WPUser class] fromJSONDictionary:value error:&error];
        if (error) {
            NSLog(@"%@", error);
        }
        
        return author;
        
    } reverseBlock:^id(WPUser *value) {
        if (!value) {
            return nil;
        }
        return [MTLJSONAdapter JSONDictionaryFromModel:value];
    }];
}

+ (NSValueTransformer *)creationDateJSONTransformer
{
    return [NSValueTransformer wp_dateTimeValueTransformer];
}

+ (NSValueTransformer *)modifiedDateJSONTransformer
{
    return [NSValueTransformer wp_dateTimeValueTransformer];
}

+ (NSValueTransformer *)URLJSONTransformer
{
    return [NSValueTransformer wp_URLValueTansformer];
}

+ (NSValueTransformer *)shortURLJSONTransformer
{
    return [NSValueTransformer wp_URLValueTansformer];
}

+ (NSValueTransformer *)statusJSONTransformer
{
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^id(NSString *value) {
        WPPostStatus status = WPPostStatusUnknown;
        if ([value isEqualToString:@"publish"]) {
            status = WPPostStatusPublish;
        } else if ([value isEqualToString:@"draft"]) {
            status = WPPostStatusDraft;
        } else if ([value isEqualToString:@"pending"]) {
            status = WPPostStatusPending;
        } else if ([value isEqualToString:@"private"]) {
            status = WPPostStatusPrivate;
        } else if ([value isEqualToString:@"future"]) {
            status = WPPostStatusFuture;
        } else if ([value isEqualToString:@"trash"]) {
            status = WPPostStatusTrash;
        } else if ([value isEqualToString:@"auto-draft"]) {
            status = WPPostStatusAutoDraft;
        }
        return @(status);
        
    } reverseBlock:^id(NSNumber *value) {
        WPPostStatus status = [value integerValue];
        NSString *result;
        
        switch (status) {
            case WPPostStatusPublish: {
                result = @"publish";
                break;
            }
            case WPPostStatusDraft: {
                result = @"draft";
                break;
            }
            case WPPostStatusPending: {
                result = @"pending";
                break;
            }
            case WPPostStatusPrivate: {
                result = @"private";
                break;
            }
            case WPPostStatusFuture: {
                result = @"future";
                break;
            }
            case WPPostStatusTrash: {
                result = @"trash";
                break;
            }
            case WPPostStatusAutoDraft: {
                result = @"auto-draft";
                break;
            }
            default:
                break;
        }
        return result;
    }];
}

+ (NSValueTransformer *)featuredImageURLJSONTransformer
{
    return [NSValueTransformer wp_URLValueTansformer];
}

+ (NSValueTransformer *)thumbnailURLJSONTransformer
{
    return [NSValueTransformer wp_URLValueTansformer];
}

+ (NSValueTransformer *)formatJSONTransformer
{
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^id(NSString *value) {
        WPPostFormat format = WPPostFormatUnknown;

        if ([value isEqualToString:@"standard"]) {
            format = WPPostFormatStandard;
        } else if ([value isEqualToString:@"aside"]) {
            format = WPPostFormatAside;
        } else if ([value isEqualToString:@"chat"]) {
            format = WPPostFormatChat;
        } else if ([value isEqualToString:@"gallery"]) {
            format = WPPostFormatGallery;
        } else if ([value isEqualToString:@"link"]) {
            format = WPPostFormatLink;
        } else if ([value isEqualToString:@"image"]) {
            format = WPPostFormatImage;
        } else if ([value isEqualToString:@"quote"]) {
            format = WPPostFormatQuote;
        } else if ([value isEqualToString:@"status"]) {
            format = WPPostFormatStatus;
        } else if ([value isEqualToString:@"video"]) {
            format = WPPostFormatVideo;
        } else if ([value isEqualToString:@"audio"]) {
            format = WPPostFormatAudio;
        }
        return @(format);
        
    } reverseBlock:^id(NSNumber *value) {
        WPPostFormat format = [value integerValue];
        NSString *result;
        
        switch (format) {
            case WPPostFormatStandard: {
                result = @"standard";
                break;
            }
            case WPPostFormatAside: {
                result = @"aside";
                break;
            }
            case WPPostFormatChat: {
                result = @"chat";
                break;
            }
            case WPPostFormatGallery: {
                result = @"gallery";
                break;
            }
            case WPPostFormatLink: {
                result = @"link";
                break;
            }
            case WPPostFormatImage: {
                result = @"image";
                break;
            }
            case WPPostFormatQuote: {
                result = @"quote";
                break;
            }
            case WPPostFormatStatus: {
                result = @"status";
                break;
            }
            case WPPostFormatVideo: {
                result = @"video";
                break;
            }
            case WPPostFormatAudio: {
                result = @"audio";
                break;
            }
                
            default:
                break;
        }
        return result;
    }];
}

@end
