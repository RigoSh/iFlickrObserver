//
//  FlickrProvider.m
//  iFlickrObserver
//
//  Created by Shuvalov Igor on 30/05/2017.
//  Copyright © 2017 Shuvalov Igor. All rights reserved.
//

#import "FlickrProvider.h"

@implementation FlickrProvider

+ (NSURL *)URLForQuery:(NSString *)query
{
    query = [NSString stringWithFormat:@"%@&format=json&nojsoncallback=1&tagmode=any", query];
    NSCharacterSet *set = [NSCharacterSet URLQueryAllowedCharacterSet];
    
    query = [query stringByAddingPercentEncodingWithAllowedCharacters:set];        //NSUTF8StringEncoding
    
    return [NSURL URLWithString:query];
}

+ (NSURL *)URLforSearchWithTags:(NSString *)tags
{
    return [self URLForQuery:[NSString stringWithFormat:@"https://api.flickr.com/services/feeds/photos_public.gne/?tags=%@", tags]];
}

+ (NSURL *)getURLforDownloadingPhoto:(NSDictionary *)photo
{
    return [NSURL URLWithString:[photo valueForKeyPath:FLICKR_PHOTO_MEDIA]];
}

@end
