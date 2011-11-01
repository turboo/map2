//
//  DetailInfoTableViewController.m
//  MapView
//
//  Created by MBP on 10/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DetailInfoTableViewController.h"

@implementation DetailInfoTableViewController

@synthesize detailWebView, hotelID;
@synthesize tvCell;

//@synthesize tvCell;
const CGFloat kScrollObjHeight	= 200.0;
const CGFloat kScrollObjWidth	= 285.0;
const NSUInteger kNumImages		= 3;
//
//  self add init
//
- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	return [self initWithHotelID:nil];
}

- (id) initWithHotelID:(NSNumber *)hotelID
{
  NSLog(@"initWithHotelID:%@",hotelID);
	self = [super initWithNibName:nil bundle:nil];
	if (!self)
		return nil;
	
	self.hotelID = hotelID;
	return self;
}

//
//  system init
//
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    SearchHotelQuery *searchQuery = [[[SearchHotelQuery alloc]init]autorelease];
    UIImage *hotelFavorite = [searchQuery inputHotelIDAndShowFavorites:hotelID];
    self.navigationItem.rightBarButtonItem =[[[UIBarButtonItem alloc]initWithImage:hotelFavorite style:UIBarButtonItemStylePlain target:self action:@selector(setFavorite)]autorelease];
    hotelFavorite = nil;
    searchQuery = nil;
    [super viewDidLoad];
}

-(void)setFavorite
{
//    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"This is about myFavorite" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil ] autorelease];
//    
//    [alert show];
  SearchHotelQuery *searchQuery = [[[SearchHotelQuery alloc]init]autorelease];
  self.navigationItem.rightBarButtonItem.image = [searchQuery inputHotelIDAndModifyFavorites:hotelID showStatus:YES];
  searchQuery = nil;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //
    //  database init
    //
    SearchHotelQuery *HotelQuery=[[SearchHotelQuery alloc] init];
    Hotel *hotelDetails =[[Hotel alloc] init];
    hotelDetails = [HotelQuery inputHotelIDAndListDataAndChange:self.hotelID];
    NSString *loadedString = [NSString stringWithFormat:
                              @"<html>"
                              @"<head>"
                              @"<BASE href='http://taipeitravel.net/'>"
                              @"</head><body>"
                              @"%@"
                              @"</body></html>",hotelDetails.descriptionHTML];
    
    NSLog(@"hotelDetails.displayName = %@" , hotelDetails.displayName);
    
    //
    //  cell init
    //   
    static NSString *CustomCellIdentifier = @"CustomCellIdentifier";
	
    UITableViewCell *cell = [tableView
                             dequeueReusableCellWithIdentifier: CustomCellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomCell_detail"
                                                     owner:self options:nil];
        if ([nib count] > 0) {
            cell = self.tvCell;
        } else {
            NSLog(@"failed to load CustomCell nib file!");
        }
    }	
    
    // Configure the cell...
    UILabel *hotelDisplayName = (UILabel *)[cell viewWithTag:1];
    hotelDisplayName.text = hotelDetails.displayName;
	
    UILabel *hotelAreaName = (UILabel *)[cell viewWithTag:2];
    hotelAreaName.text = hotelDetails.areaName;
  
    self.navigationItem.title = hotelDetails.displayName;
    //NSLog(@"hotelDetails.areaName = %@",hotelDetails.areaName);
    //NSLog(@"hotelAreaName.text = %@",hotelAreaName.text);
    //self.view.backgroundColor = [UIColor viewFlipsideBackgroundColor];
    CGRect ScrollSize=CGRectMake(20, 80, kScrollObjWidth, kScrollObjHeight);
    PicScrollView=[[UIScrollView alloc ]initWithFrame:ScrollSize];
    [PicScrollView setBackgroundColor:[UIColor blackColor]];
    [PicScrollView setCanCancelContentTouches:NO];
    PicScrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    PicScrollView.clipsToBounds = YES;
    PicScrollView.scrollEnabled = YES;
    PicScrollView.pagingEnabled = YES;

    
    //NSLog(@"image len=%d" , [hotelDetails.imagesArray length]);
    NSArray * imagesArray = [hotelDetails.imagesArray componentsSeparatedByString:@";"];
    
    int i=0;
    ImageOnURL *ImageURL=[[ImageOnURL alloc]init];
    for(NSString* imagesURL in imagesArray){
        imagesURL = [imagesURL stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if ([imagesURL length]>0){
            
            i++;  
            //NSLog(@"imagesURL字串：%@",imagesURL);
            //UIImageView *myImageView=[[UIImageView alloc] initWithImage:[[UIImage description:[NSString stringWithFormat:@"%@",hotelDetails.displayName]] sendURLReturnImage:imagesURL]];
            
            UIImageView *myImageView=[[UIImageView alloc] initWithImage:[ImageURL sendURLReturnImage:imagesURL]];
            
            //UIImageView *myImageView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tokyo_hotel.jpg"]];
            
            CGRect rect = myImageView.frame;
            rect.size.height = kScrollObjHeight;
            rect.size.width = kScrollObjWidth;
            myImageView.frame = rect;
            myImageView.tag = i;	
            [PicScrollView addSubview:myImageView];
            [myImageView release];
        }
    }
    imagesArray = nil;
    [cell addSubview:PicScrollView];
    
    [self layoutScrollImages];
    
    CGRect WebViewSize=CGRectMake(20,280,kScrollObjWidth, 600);
	UIWebView *detailWebView = [[UIWebView alloc] initWithFrame:WebViewSize];
    //UIWebView *detailWebView = [[UIWebView alloc] init];
    //[detailWebView scalesPageToFit:YES];
    
 	[detailWebView loadHTMLString:loadedString baseURL:nil];
    [cell addSubview:detailWebView];


    return cell;
}

- (void)layoutScrollImages
{
	UIImageView *URLIMageView = nil;
	NSArray *subviews = [PicScrollView subviews];
	CGFloat curXLoc = 0;
	for (URLIMageView in subviews)
	{
		if ([URLIMageView isKindOfClass:[UIImageView class]] && URLIMageView.tag > 0)
		{
			CGRect frame = URLIMageView.frame;
			frame.origin = CGPointMake(curXLoc, 0);
			URLIMageView.frame = frame;
			curXLoc += (kScrollObjWidth);
		}
	}
	// set the content size so it can be scrollable
	[PicScrollView setContentSize:CGSizeMake((kNumImages * kScrollObjWidth), [PicScrollView bounds].size.height)];
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
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
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
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   // CGFloat height=tableView.rowHeight;
   // if(indexPath.section == 5 )
       return 1200;
    
   // return height;
}

- (void)dealloc {
  [PicScrollView release];
  [detailWebView release];
  [super dealloc];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

@end
