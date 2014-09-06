//
//  ExerciseTableViewController.m
//  ListViewExercise
//
//  Created by Mark Angeles on 9/5/14.
//  Copyright (c) 2014 Chua's Company. All rights reserved.
//

#import "ExerciseTableViewController.h"

@interface ExerciseTableViewController (){
    
    NSMutableArray *arrayList;

}

@property (strong, nonatomic) UIView *viewActivityFrame;

@end

@implementation ExerciseTableViewController
#pragma mark - Setter
@synthesize viewActivityFrame = _viewActivityFrame;
#pragma mark - Getter
- (UIView *)viewActivityFrame
{
    if (!_viewActivityFrame) {
        _viewActivityFrame = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        [_viewActivityFrame setBackgroundColor:[UIColor blackColor]];
        [_viewActivityFrame setAlpha:.8];
        
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [activityIndicator startAnimating];
        [activityIndicator setFrame:CGRectMake(0, 0, self.viewActivityFrame.frame.size.width, self.viewActivityFrame.frame.size.height)];
        [_viewActivityFrame addSubview:activityIndicator];
    }
    return _viewActivityFrame;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Use operation que to download images
    // Set max operation to 1
    mainQue = [[NSOperationQueue alloc]init];
    [mainQue setMaxConcurrentOperationCount:1];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    
    arrayList = @[].mutableCopy;
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.view addSubview:self.viewActivityFrame];
    
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // Load webservice after all the view is loaded
    [self getListOfFacts];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [arrayList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"exerciseCell";
    ExerciseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    
    if (cell == nil) {
        cell = [[ExerciseTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Get objects to present on table view
    FactsObject *facts = (FactsObject *)arrayList[indexPath.row];
    [cell.activityIndicator startAnimating];
    [cell.imageDisplay setBackgroundColor:[UIColor blackColor]];
    [cell.labelTitle setText:facts.stringTitle];
    [cell.labelDescription setText:facts.stringDescription];
    if ([[NSFileManager defaultManager] fileExistsAtPath:facts.stringImagePath]) {
        [cell.imageDisplay setImage:[UIImage imageWithContentsOfFile:facts.stringImagePath]];
        [cell.activityIndicator stopAnimating];
        [cell.activityIndicator setHidden:YES];
    }
//
    
    // Configure the cell...
    
    return cell;
}

#pragma mark - Sub Functions
// Webservice
- (void)getListOfFacts
{
    NSURL *url = [NSURL URLWithString:WEB_LINK_GET_LIST];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    
    NSLog(@"Get List = %@",url);
    AFHTTPRequestOperation *afRequest = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [afRequest setResponseSerializer:[AFJSONResponseSerializer serializer]];
    
    
    [afRequest setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"Response = %@",responseObject);
        [arrayList removeAllObjects];
        // Parse the JSON
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dictionaryResponse = (NSDictionary *)responseObject;
            NSArray *arrayRows = (NSArray *)dictionaryResponse[@"rows"];
            __block NSMutableArray *arrayHolder = @[].mutableCopy;
            [arrayRows enumerateObjectsUsingBlock:^(NSDictionary *dictionaryRow, NSUInteger idx, BOOL *stop) {
                FactsObject *facts = [[FactsObject alloc]init];
                if (dictionaryRow[@"title"] != [NSNull null]) {
                    facts.stringTitle = dictionaryRow[@"title"];
                    
                }
                
                if (dictionaryRow[@"description"] != [NSNull null]) {
                    
                    facts.stringDescription = dictionaryRow[@"description"];
                }
                if (dictionaryRow[@"imageHref"] != [NSNull null]) {
                    
                    facts.stringImageURL = dictionaryRow[@"imageHref"];
                    // Download the image using operation que
                    ImageDownloader *downloadImage = [[ImageDownloader alloc]init];
                    downloadImage.stringImageName = facts.stringTitle;
                    downloadImage.stringDirectory = facts.stringImageFolder;
                    downloadImage.stringURL = facts.stringImageURL;
                    downloadImage.index = idx;
                    [downloadImage setDelegate:self];
                    [mainQue addOperation:downloadImage];
                    
                    
                }
                
                
                
                [arrayHolder addObject:facts];
            }];
            [arrayList addObjectsFromArray:arrayHolder];
        }
        
        
        [self.viewActivityFrame setHidden:YES];
        [self.tableView reloadData];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"ERROR == %@",[error localizedDescription]);
        
    
    }];
    [afRequest start];
}

#pragma mark - Delegate
#pragma mark Image Downloader
- (void)imageDownloader:(ImageDownloader *)downloader finishDownloading:(UIImage *)image
{
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSLog(@"Downloaded images %@",path[0]);
    dispatch_sync(dispatch_get_main_queue(), ^{
        // Reload table to update UI after an image is downloaded
        [self.tableView reloadData];
    });
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
