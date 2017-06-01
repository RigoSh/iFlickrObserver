//
//  DetailPhotoViewController.h
//  iFlickrObserver
//
//  Created by Shuvalov Igor on 30/05/2017.
//  Copyright © 2017 Shuvalov Igor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlickrPhotoObject.h"

@interface DetailPhotoViewController : UIViewController

@property (weak, nonatomic) FlickrPhotoObject *photoObject;

@end
