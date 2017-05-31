//
//  FlickrPhotoObject.h
//  iFlickrObserver
//
//  Created by Shuvalov Igor on 31/05/2017.
//  Copyright © 2017 Shuvalov Igor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FlickrProvider.h"
#import "FlickrProvider.h"

@interface FlickrPhotoObject : NSObject

+ (NSURL *)URLforDownloadingPhoto:(NSDictionary *)photo;

+ (NSString *)TitleKeyForPhoto:(NSDictionary *)photo;
+ (NSString *)TagsKeyForPhoto:(NSDictionary *)photo;
+ (NSString *)DatePublishedKeyForPhoto:(NSDictionary *)photo;

@end
