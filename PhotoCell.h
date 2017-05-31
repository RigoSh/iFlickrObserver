//
//  PhotoCell.h
//  iFlickrObserver
//
//  Created by Shuvalov Igor on 30/05/2017.
//  Copyright © 2017 Shuvalov Igor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoCell : UITableViewCell

@property (copy, nonatomic) NSString *titleStr;
@property (copy, nonatomic) NSString *dateStr;
@property (copy, nonatomic) NSString *tagsStr;

@end
