//
//  FlickrProvider.h
//  iFlickrObserver
//
//  Created by Shuvalov Igor on 30/05/2017.
//  Copyright © 2017 Shuvalov Igor. All rights reserved.
//

#import <Foundation/Foundation.h>

#define FLICKR_PHOTOS @"items"

#define FLICKR_PHOTO_MEDIA @"media.m"
#define FLICKR_PHOTO_TITLE @"title"
#define FLICKR_PHOTO_DATE_PUBLISHED @"published"
#define FLICKR_PHOTO_TAGS @"tags"

@interface FlickrProvider : NSObject

+ (NSURL *)URLforSearchWithTags:(NSString *)tags;
+ (NSURL *)getURLforDownloadingPhoto:(NSDictionary *)photo;

@end
