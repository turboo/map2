//
//  MyFavoriteTableViewController.m
//  MapView
//
//  Created by App on 2011/10/27.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "MyFavoriteTableViewController.h"

@implementation MyFavoriteTableViewController
@synthesize dataFavoritesList;
//@dynamic dataFavoritesList;

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
	
    self.title=@"我的最愛";
      
    self.navigationController.navigationBar.tintColor = [UIColor   
        colorWithRed:00.0/255   
        green:128.0/255   
        blue:255.0/255   
        alpha:1];      
    self.tableView.allowsSelectionDuringEditing = YES;
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
	SearchHotelQuery *searchQuery = [[[SearchHotelQuery alloc]init]autorelease];
	dataFavoritesList = [[NSMutableArray alloc]initWithArray:[searchQuery showFavoritesList]];
	searchQuery = nil;
}

-(void)reflaseDataWithTable
{
	[dataFavoritesList removeAllObjects];
	SearchHotelQuery *searchQuery = [[[SearchHotelQuery alloc]init]autorelease];	
	[dataFavoritesList addObjectsFromArray:[searchQuery showFavoritesList]];
	searchQuery = nil;
	[self.tableView reloadData];
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
	[self reflaseDataWithTable];
}

- (void)viewDidAppear:(BOOL)animated
{
	//[self.tableView reloadData];
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	//[self.tableView reloadData];
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	//[self.tableView reloadData];
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
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [dataFavoritesList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    cell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
    NSUInteger row=[indexPath row];
  
  //顯示開始
	TableViewItem *myFavoriteListEntity = [dataFavoritesList objectAtIndex:indexPath.row];  
  //顯示圖片  
	NSLog(@"imagesArray = %@" , myFavoriteListEntity.imagesArray);
  //顯示旅館名稱
	[cell.textLabel setText:myFavoriteListEntity.displayName];
  //顯示附標：旅館距離、ㄝ地址
  double_t distance = [myFavoriteListEntity.distance doubleValue];
	[cell.detailTextLabel setText:(distance>=1000)?[NSString stringWithFormat:@"(距離 %4.2f km) %@",distance/1000,myFavoriteListEntity.address]:[NSString stringWithFormat:@"(距離 %3f m) %@",distance,myFavoriteListEntity.address] ];
  //顯示結束 
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
      // Delete the row from the data source
      TableViewItem *delItem = [dataFavoritesList objectAtIndex:indexPath.row];
      SearchHotelQuery *searchQuery = [[[SearchHotelQuery alloc]init]autorelease];
      [searchQuery inputHotelIDAndModifyFavorites:delItem.odIdentifier showStatus:NO];
      searchQuery = nil;
      [dataFavoritesList removeObjectAtIndex:indexPath.row];
      [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


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
    TableViewItem *selItem = [dataFavoritesList objectAtIndex:indexPath.row];
    DetailInfoTableViewController *detailsView = [[[DetailInfoTableViewController alloc]initWithHotelID:selItem.odIdentifier] autorelease];
    [self.navigationController pushViewController:detailsView animated:YES];
}

@end
