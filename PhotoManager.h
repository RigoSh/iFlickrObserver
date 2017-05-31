//
//  PhotoManager.h
//  iFlickrObserver
//
//  Created by Shuvalov Igor on 30/05/2017.
//  Copyright © 2017 Shuvalov Igor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhotoManager : NSObject

+ (instancetype) sharedInstance;

- (void) fetchPhotosWithTags:(NSString *)tags
                     success:(void(^)(id responseObject))handler
                        fail:(void(^)(NSError *error))error;

- (NSURL *)URLforDownloadingPhoto:(NSDictionary *)photo;

@end
