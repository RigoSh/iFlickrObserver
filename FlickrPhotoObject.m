//
//  FlickrPhotoObject.m
//  iFlickrObserver
//
//  Created by Shuvalov Igor on 31/05/2017.
//  Copyright © 2017 Shuvalov Igor. All rights reserved.
//

#import "FlickrPhotoObject.h"

@implementation FlickrPhotoObject

+ (NSURL *)URLforDownloadingPhoto:(NSDictionary *)photo
{
    return [FlickrProvider getURLforDownloadingPhoto:photo];
}

+ (NSString *)TitleKeyForPhoto:(NSDictionary *)photo
{
    return photo[FLICKR_PHOTO_TITLE];
}

+ (NSString *)TagsKeyForPhoto:(NSDictionary *)photo
{
    return photo[FLICKR_PHOTO_TAGS];
}

+ (NSString *)DatePublishedKeyForPhoto:(NSDictionary *)photo
{
    return photo[FLICKR_PHOTO_DATE_PUBLISHED];
}

@end
