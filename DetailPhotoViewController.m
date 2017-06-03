//
//  DetailPhotoViewController.m
//  iFlickrObserver
//
//  Created by Shuvalov Igor on 30/05/2017.
//  Copyright © 2017 Shuvalov Igor. All rights reserved.
//

#import "DetailPhotoViewController.h"
#import "PhotoManager.h"

@interface DetailPhotoViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;

@end

@implementation DetailPhotoViewController
{
    PhotoManager *_photoManager;
    UIDocumentInteractionController *_photoDIC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _photoManager = [PhotoManager sharedInstance];
    _photoDIC = [UIDocumentInteractionController new];
    
    [self showPhoto];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showPhoto
{
    if(self.photoObject.imageData)
    {
        self.photoImageView.image = [UIImage imageWithData:self.photoObject.imageData];
    }
    else
    {
        [self.indicatorView startAnimating];
        
        [_photoManager downloadImageFromURL:self.photoObject.imageURLString success:^(id responseObject) {
            self.photoObject.imageData = responseObject;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.indicatorView stopAnimating];
                self.photoImageView.image = [UIImage imageWithData:responseObject];
            });
        } fail:^(NSError *error) {
            NSLog(@"downloading error: %@", [error localizedDescription]);
        }];
    }
}

- (IBAction)sharePhoto:(id)sender
{
    if(self.photoObject.imageData)
    {
        NSString *basePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
        NSString *sharedImageFileName = @"temporary_shared_image.png";
        
        if([self.photoObject.imageData writeToFile:[basePath stringByAppendingPathComponent:sharedImageFileName] atomically:YES])
        {
            NSURL* documentsUrl = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask].firstObject;
            NSURL* sharedImageUrl = [documentsUrl URLByAppendingPathComponent:sharedImageFileName];

            if(sharedImageUrl)
            {
                _photoDIC.URL = sharedImageUrl;
                [_photoDIC presentOptionsMenuFromBarButtonItem:sender animated:YES];
            }
        }
    }
}

@end
