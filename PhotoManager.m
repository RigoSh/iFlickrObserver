//
//  PhotoManager.m
//  iFlickrObserver
//
//  Created by Shuvalov Igor on 30/05/2017.
//  Copyright © 2017 Shuvalov Igor. All rights reserved.
//

#import "PhotoManager.h"
#import "FlickrProvider.h"

@implementation PhotoManager

+(instancetype) sharedInstance
{
    static PhotoManager *_instance = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _instance = [[PhotoManager alloc] init];
    });
    
    return _instance;
}

- (void) fetchPhotosWithTags:(NSString *)tags
                     success:(void(^)(id responseObject))successHandler
                        fail:(void(^)(NSError *error))failHandler
{
    NSURL *searchURL = [FlickrProvider URLforSearchWithTags:tags];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDownloadTask *task = [session downloadTaskWithURL:searchURL completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if(!error)
        {
            NSData *jsonDataResult = [NSData dataWithContentsOfURL:searchURL];
            NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:jsonDataResult options:0 error:NULL];
            
            NSArray *photoItems = [resultDict valueForKeyPath:FLICKR_PHOTOS];
            
            successHandler(photoItems);
        }
        else
        {
            failHandler(error);
        }
    }];
    
    [task resume];
}

- (NSURL *)URLforDownloadingPhoto:(NSDictionary *)photo
{
    return [FlickrProvider getURLforDownloadingPhoto:photo];
}

@end
