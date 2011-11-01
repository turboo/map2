//
//  HistoryTableViewController.m
//  MapView
//
//  Created by App on 2011/10/27.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "HistoryTableViewController.h"

@implementation HistoryTableViewController

@dynamic dataHistoryList;

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
	
    self.title=@"瀏覽紀錄";
    self.navigationController.navigationBar.tintColor = [UIColor   
                                                       colorWithRed:00.0/255   
                                                       green:128.0/255   
                                                       blue:255.0/255   
                                                       alpha:1];   
    UIBarButtonItem *item = [[UIBarButtonItem alloc]   
                             initWithBarButtonSystemItem:UIBarButtonSystemItemTrash   
                             target:self   
                             action:@selector(cleanHistory)];  
    self.navigationItem.rightBarButtonItem = item;
  
  
    SearchHotelQuery *searchQuery = [[[SearchHotelQuery alloc]init]autorelease];
    dataHistoryList = [[NSMutableArray alloc]initWithArray:[searchQuery showHistoryList]];
    searchQuery = nil;
    [item release];  
}
-(void)reflaseDataWithTable
{
	[dataHistoryList removeAllObjects];
	SearchHotelQuery *searchQuery = [[[SearchHotelQuery alloc]init]autorelease];	
	[dataHistoryList addObjectsFromArray:[searchQuery showHistoryList]];
	searchQuery = nil;
	[self.tableView reloadData];
}

-(void)cleanHistory{
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"要清空瀏覽記錄嗎？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"確定",nil ] autorelease];
    
    [alert show];
    
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {     // and they clicked 1.
        NSLog(@"cancel clicked");
    }else if(buttonIndex==1){
        NSLog(@"OK clicked");
      SearchHotelQuery *searchQuery = [[[SearchHotelQuery alloc]init]autorelease];
      [searchQuery allDeleteuseDate];
      searchQuery = nil;
      [dataHistoryList removeAllObjects];
      [self.tableView reloadData];
    }
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
    return [dataHistoryList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    cell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;

    // Configure the cell...
    //顯示開始
    TableViewItem *myHistoryListEntity = [dataHistoryList objectAtIndex:indexPath.row];  
    //顯示圖片  
    NSLog(@"imagesArray = %@" , myHistoryListEntity.imagesArray);
    //顯示旅館名稱
    [cell.textLabel setText:myHistoryListEntity.displayName];
    //顯示附標：旅館距離、ㄝ地址
    double_t distance = [myHistoryListEntity.distance doubleValue];
    [cell.detailTextLabel setText:(distance>=1000)?[NSString stringWithFormat:@"(距離 %4.2f km) %@",distance/1000,myHistoryListEntity.address]:[NSString stringWithFormat:@"(距離 %3f m) %@",distance,myHistoryListEntity.address] ];
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
  TableViewItem *selItem = [dataHistoryList objectAtIndex:indexPath.row];
  DetailInfoTableViewController *detailsView = [[[DetailInfoTableViewController alloc]initWithHotelID:selItem.odIdentifier] autorelease];
  [self.navigationController pushViewController:detailsView animated:YES];
}

@end
