//
//  PhotoCell.m
//  iFlickrObserver
//
//  Created by Shuvalov Igor on 30/05/2017.
//  Copyright © 2017 Shuvalov Igor. All rights reserved.
//

#import "PhotoCell.h"


@interface PhotoCell()

@property (weak, nonatomic) IBOutlet UILabel *photoTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *photoDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *photoTagsLabel;

@end

@implementation PhotoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTitleStr:(NSString *)titleStr
{
    self.photoTitleLabel.text = titleStr;
}

- (void)setDateStr:(NSString *)dateStr
{
    self.photoDateLabel.text = dateStr;
}

- (void)setTagsStr:(NSString *)tagsStr
{
    self.photoTagsLabel.text = tagsStr;
}

@end
