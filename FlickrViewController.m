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

@end

@implementation FlickrViewController
{
    NSMutableArray *_photosArray;
    PhotoManager *_photoManager;
    NSInteger _pageNum;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _photoManager = [PhotoManager sharedInstance];
    _photosArray = [NSMutableArray new];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - internal functions

- (IBAction)searchButtonPressed:(id)sender
{
    [self.searchTextField resignFirstResponder];
    [self firstPageDownloading];
}

- (void)firstPageDownloading
{
    _pageNum = 1;
    
    [_photosArray removeAllObjects];
    [self.tableView reloadData];
    
    NSString *searchingString = [self.searchTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if(searchingString.length != 0)
    {
        [self downloadPageAtNumber:_pageNum];
    }
}

- (void)nextPageDownloading
{
    [self downloadPageAtNumber:_pageNum+1];
}

- (void)downloadPageAtNumber:(NSInteger)pageNumber
{
    [self.searchIndicator startAnimating];
    
    [_photoManager fetchPhotosWithTags:self.searchTextField.text andSortMode:self.sortMethod.selectedSegmentIndex andPageNum:_pageNum success:^(id responseObject) {
        
        for (NSDictionary *object in responseObject)
        {
            FlickrPhotoObject *newPhoto = [[FlickrPhotoObject alloc] initWithObject:object];
            [_photosArray addObject:newPhoto];
        }
        _pageNum++;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.searchIndicator stopAnimating];
            [self.tableView reloadData];
        });
    } fail:^(NSError *error) {
        [self.searchIndicator stopAnimating];
        NSLog(@"searching error: %@", [error localizedDescription]);
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _photosArray.count;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self firstPageDownloading];
    
    return YES;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:key_photoID forIndexPath:indexPath];
    
    FlickrPhotoObject *photo = _photosArray[indexPath.row];
    
    cell.titleStr = photo.title;
    cell.dateStr = photo.datePublished;
    cell.tagsStr = photo.tags;
    cell.photoImage = nil;
    
    if(photo.imageURLString)
    {
        if(photo.imageData)
        {
            cell.photoImage = [UIImage imageWithData:photo.imageData];
        }
        else
        {
            cell.shouldStartPhotoIndicator = YES;
            
            [_photoManager downloadImageFromURL:photo.imageURLString success:^(id responseObject) {
                photo.imageData = responseObject;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    cell.shouldStartPhotoIndicator = NO;
                    cell.photoImage = [UIImage imageWithData:responseObject];
                });
            } fail:^(NSError *error) {
                NSLog(@"downloading error: %@", [error localizedDescription]);
            }];
        }
    }
    else
    {
        cell.photoImage = [UIImage imageNamed:@"photo-empty"];
    }
        
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([indexPath row] == (_photosArray.count - 1))
    {
        [self nextPageDownloading];
    }
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([sender isKindOfClass:[PhotoCell class]])
    {
        NSIndexPath *path = [self.tableView indexPathForCell:sender];
        
        if(path && [segue.identifier isEqualToString:key_photoSegueID])
        {
            id destVC = segue.destinationViewController;
            
            FlickrPhotoObject *photo = _photosArray[path.row];
            
            [destVC setValue:photo forKey:@"photoObject"];
        }
    }
}

@end
