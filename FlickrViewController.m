//
//  FlickrViewController.m
//  iFlickrObserver
//
//  Created by Shuvalov Igor on 30/05/2017.
//  Copyright © 2017 Shuvalov Igor. All rights reserved.
//

#import "FlickrViewController.h"
#import "PhotoManager.h"
#import "FlickrProvider.h"  // избавиться от него!
#import "PhotoCell.h"
#import "DetailPhotoViewController.h"

static NSString* const key_photoID = @"photoID";
static NSString* const key_photoSegueID = @"DetailPhotoSegueID";

@interface FlickrViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *sortMethod;

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
    _photosArray = photosArray;
    
//    dispatch_sync(dispatch_get_main_queue(), ^{
//       [self.tableView reloadData];
//    });
    
    [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
}

- (IBAction)searchButtonPressed:(id)sender
{
    NSString *searchingString = [self.searchTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    [self.photoManager fetchPhotosWithTags:searchingString success:^(id responseObject) {

        NSArray *sortedArray = nil;
        
        switch (self.sortMethod.selectedSegmentIndex) {
            case 0:
                sortedArray = [responseObject sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:FLICKR_PHOTO_TITLE ascending: true]]];
                break;
            case 1:
                sortedArray = [responseObject sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:FLICKR_PHOTO_DATE_PUBLISHED ascending: false]]];
                break;
            default:
                break;
        }
        
        self.photosArray = sortedArray;
    } fail:^(NSError *error) {
        NSLog(@"searching error: %@", [error localizedDescription]);
    }];
}

- (IBAction)sortMethodChanged:(id)sender
{
    NSArray *sortedArray = nil;
    
    switch (self.sortMethod.selectedSegmentIndex) {
        case 0:
            sortedArray = [self.photosArray sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:FLICKR_PHOTO_TITLE ascending: true]]];
            break;
        case 1:
            sortedArray = [self.photosArray sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:FLICKR_PHOTO_DATE_PUBLISHED ascending: false]]];
            break;
        default:
            break;
    }
    
    self.photosArray = sortedArray;
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


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:key_photoID forIndexPath:indexPath];
    
    NSDictionary *photo = self.photosArray[indexPath.row];
    
    cell.titleStr = photo[FLICKR_PHOTO_TITLE];
    cell.dateStr = photo[FLICKR_PHOTO_DATE_PUBLISHED];
    cell.tagsStr = photo[FLICKR_PHOTO_TAGS];
    
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
            NSURL *photoURL = [self.photoManager URLforDownloadingPhoto:photo];
            
            [destVC setValue:photoURL forKey:@"photoURL"];
        }
    }
}

@end
