//
//  FlickrViewController.m
//  iFlickrObserver
//
//  Created by Shuvalov Igor on 30/05/2017.
//  Copyright © 2017 Shuvalov Igor. All rights reserved.
//

#import "FlickrViewController.h"
#import "PhotoManager.h"
#import "PhotoCell.h"
#import "DetailPhotoViewController.h"
#import "FlickrPhotoObject.h"

static NSString* const key_photoID = @"photoID";
static NSString* const key_photoSegueID = @"DetailPhotoSegueID";

@interface FlickrViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *sortMethod;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *searchIndicator;

@property (strong, nonatomic) NSArray *photosArray;
@property (strong, nonatomic) PhotoManager *photoManager;

@end

@implementation FlickrViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.photoManager = [PhotoManager sharedInstance];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - internal functions

- (void)setPhotosArray:(NSArray *)photosArray
{
    [self.searchIndicator stopAnimating];
    
    _photosArray = photosArray;
    [self.tableView reloadData];
}

- (IBAction)searchButtonPressed:(id)sender
{
    self.photosArray = nil;
    
    NSString *searchingString = [self.searchTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if(0 == searchingString.length)
    {
        return;
    }
    
    [self.searchIndicator startAnimating];
    
    [self.photoManager fetchPhotosWithTags:searchingString success:^(id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.photosArray = [self sortArray:responseObject withMode:self.sortMethod.selectedSegmentIndex];
        });
    } fail:^(NSError *error) {
        NSLog(@"searching error: %@", [error localizedDescription]);
    }];
}

- (IBAction)sortMethodChanged:(id)sender
{
    self.photosArray = [self sortArray:self.photosArray withMode:self.sortMethod.selectedSegmentIndex];
}

- (NSArray *)sortArray:(NSArray *)array withMode:(NSInteger)mode
{
    NSArray *sortedArray = nil;
    
    switch (mode)
    {
        case 0:
            sortedArray = [array sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:FLICKR_PHOTO_TITLE ascending: true]]];
            break;
        case 1:
            sortedArray = [array sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:FLICKR_PHOTO_DATE_PUBLISHED ascending: false]]];
            break;
        default:
            break;
    }
    
    return sortedArray;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.photosArray.count;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    return YES;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:key_photoID forIndexPath:indexPath];
    
    NSDictionary *photo = self.photosArray[indexPath.row];
    
    cell.titleStr = [FlickrPhotoObject TitleKeyForPhoto:photo];
    cell.dateStr = [FlickrPhotoObject DatePublishedKeyForPhoto:photo];
    cell.tagsStr = [FlickrPhotoObject TagsKeyForPhoto:photo];
    
    return cell;
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([sender isKindOfClass:[PhotoCell class]])
    {
        NSIndexPath *path = [self.tableView indexPathForCell:sender];
        
        if(path && [segue.identifier isEqualToString:key_photoSegueID])
        {
            id destVC = segue.destinationViewController;
            
            NSDictionary *photo = self.photosArray[path.row];
            NSURL *photoURL = [FlickrPhotoObject URLforDownloadingPhoto:photo];
            
            [destVC setValue:photoURL forKey:@"photoURL"];
        }
    }
}

@end
