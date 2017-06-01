//
//  FlickrProvider.m
//  iFlickrObserver
//
//  Created by Shuvalov Igor on 30/05/2017.
//  Copyright © 2017 Shuvalov Igor. All rights reserved.
//

#import "FlickrProvider.h"

@implementation FlickrProvider

+ (NSURL *)URLforSearchWithTags:(NSString *)tags
                    andSortMode:(NSInteger)mode
                     andPageNum:(NSInteger)pageNum
{
    NSString *trimTags = [tags stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *sort = (mode ? @"date-posted-desc" : @"relevance");
    
    NSString *query = [NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=%@&page=%ld&tags=%@&tag_mode=any&sort=%@&media=photos&extras=tags, url_m, date_upload&per_page=%@&format=json&nojsoncallback=1", FLICKR_API_KEY, (long)pageNum, trimTags, sort, FLCIKR_PHOTO_COUNT];
    
    NSCharacterSet *set = [NSCharacterSet URLQueryAllowedCharacterSet];
    query = [query stringByAddingPercentEncodingWithAllowedCharacters:set];        //NSUTF8StringEncoding
    
    return [NSURL URLWithString:query];
}


@end
