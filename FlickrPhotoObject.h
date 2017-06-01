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

- (id)initWithObject:(NSDictionary *)object;

@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, readonly, copy) NSString *tags;
@property (nonatomic, readonly, copy) NSString *datePublished;
@property (nonatomic, readonly, copy) NSString *imageURLString;
@property (nonatomic, strong) NSData *imageData;

@end
