//
//  FlickrProvider.h
//  iFlickrObserver
//
//  Created by Shuvalov Igor on 30/05/2017.
//  Copyright © 2017 Shuvalov Igor. All rights reserved.
//

#import <Foundation/Foundation.h>

#define FLICKR_API_KEY @"d37ed738a2133355d6e7cb07ff0c5d50"
#define FLCIKR_PHOTO_COUNT @10

#define FLICKR_PHOTOS @"photos.photo"
#define FLICKR_PHOTO_IMAGE @"url_m"
#define FLICKR_PHOTO_TITLE @"title"
#define FLICKR_PHOTO_DATE_PUBLISHED @"dateupload"
#define FLICKR_PHOTO_TAGS @"tags"

@interface FlickrProvider : NSObject

+ (NSURL *)URLforSearchWithTags:(NSString *)tags
                    andSortMode:(NSInteger)mode
                     andPageNum:(NSInteger)pageNum;

@end
