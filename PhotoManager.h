//
//  PhotoManager.h
//  iFlickrObserver
//
//  Created by Shuvalov Igor on 30/05/2017.
//  Copyright © 2017 Shuvalov Igor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhotoManager : NSObject

+ (instancetype)sharedInstance;

- (void)fetchPhotosWithTags:(NSString *)tags
                andSortMode:(NSInteger)mode
                 andPageNum:(NSInteger)pageNum
                    success:(void(^)(id responseObject))successHandler
                       fail:(void(^)(NSError *error))failHandler;

- (void)downloadImageFromURL:(NSString *)urlString
                     success:(void(^)(id responseObject))successHandler
                        fail:(void(^)(NSError *error))failHandler;

@end
