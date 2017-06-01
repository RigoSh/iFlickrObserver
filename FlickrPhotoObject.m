//
//  FlickrPhotoObject.m
//  iFlickrObserver
//
//  Created by Shuvalov Igor on 31/05/2017.
//  Copyright © 2017 Shuvalov Igor. All rights reserved.
//

#import "FlickrPhotoObject.h"

@implementation FlickrPhotoObject

- (id)initWithObject:(NSDictionary *)object
{
    if(self = [super init])
    {
        _title = object[FLICKR_PHOTO_TITLE];
        _tags = object[FLICKR_PHOTO_TAGS];
        _imageURLString = object[FLICKR_PHOTO_IMAGE];
        
        NSString *dateStrSince1970 = object[FLICKR_PHOTO_DATE_PUBLISHED];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[dateStrSince1970 integerValue]];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"dd.MM.yyyy HH:mm"];
        
        _datePublished = [formatter stringFromDate:date];
    }
    
    return self;
}

@end
