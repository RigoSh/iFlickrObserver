//
//  DetailPhotoViewController.m
//  iFlickrObserver
//
//  Created by Shuvalov Igor on 30/05/2017.
//  Copyright © 2017 Shuvalov Igor. All rights reserved.
//

#import "DetailPhotoViewController.h"

@interface DetailPhotoViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;

@property (strong, nonatomic) UIImage *photoImage;

@end

@implementation DetailPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.backBarButtonItem.title = @"назад";
    
    [self downloadingPhoto];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setPhotoImage:(UIImage *)photoImage
{
    [self.indicatorView stopAnimating];
    [self.indicatorView setHidden:YES];
    
    self.photoImageView.image = photoImage;
}

- (void)downloadingPhoto
{
    self.photoImage = nil;
    
    if(self.photoURL)
    {
        [self.indicatorView setHidden:NO];
        [self.indicatorView startAnimating];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:self.photoURL];
        NSURLSession *session = [NSURLSession sharedSession];
        
        NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if(!error)
            {
                UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:location]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.photoImage = image;
                });
            }
        }];
        
        [task resume];
    }
}

@end
