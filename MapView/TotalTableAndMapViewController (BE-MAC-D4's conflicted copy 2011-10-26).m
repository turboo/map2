//
//  TotalTableAndMapViewController.m
//  MapView
//
//  Created by MBP on 10/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TotalTableAndMapViewController.h"
#import  <QuartzCore/QuartzCore.h>

#define BTN_MAP_TITLE @"MAP"
#define BTN_StreetView_TITLE @"StreetView"

static const int kMapViewController_Accessory_StreetView = 1;
static const int kMapViewController_Accessory_Disclose = 2;

@implementation TotalTableAndMapViewController

@synthesize TotalMapView;
@synthesize TotalTableView;
@synthesize Hotels;
@synthesize MAD;
@synthesize managedObjectContext, fetchedResultsController;
@synthesize EntryTag;
@synthesize tvCell;

//
//  CoreDate init
//
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (!self)
		return nil;
	
    self.title = @"Hotel Map";
	
	self.managedObjectContext = [[MADataStore defaultStore] disposableMOC];
	self.fetchedResultsController = [[[NSFetchedResultsController alloc] initWithFetchRequest:((^ {
		return [[self class] fetchRequestInContext:self.managedObjectContext forCoordinateRegion:(MKCoordinateRegion){
			(CLLocationCoordinate2D){ 0, 0 },
			(MKCoordinateSpan){ 180, 360 }
		}];
	})()) managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil] autorelease];
	
	self.fetchedResultsController.delegate = self;
	
	NSError *fetchingError = nil;
	if (![self.fetchedResultsController performFetch:&fetchingError])
		NSLog(@"Error fetching: %@", fetchingError);
    
	return self;
}

+ (NSFetchRequest *) fetchRequestInContext:(NSManagedObjectContext *)aContext forCoordinateRegion:(MKCoordinateRegion)region {
    
	CLLocationDegrees minLat, maxLat, minLng, maxLng;
	
	minLat = region.center.latitude - region.span.latitudeDelta;
	maxLat = region.center.latitude + region.span.latitudeDelta;
	minLng = region.center.longitude - region.span.longitudeDelta;
	maxLng = region.center.longitude + region.span.longitudeDelta;
	
	NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
	
	fetchRequest.entity = [NSEntityDescription entityForName:@"Hotel" inManagedObjectContext:aContext];
	
	fetchRequest.predicate = [NSPredicate predicateWithFormat:@"(latitude >= %f) AND (latitude <= %f) AND (longitude >= %f) AND longitude <= %f", minLat, maxLat, minLng, maxLng];
    
	//fetchRequest.sortDescriptors = [NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"modificationDate" ascending:YES],nil];
    
    fetchRequest.sortDescriptors = [NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"costStay" ascending:NO],nil];
        
	//找出的資料筆數
	//NSUInteger numberOfApartments = [aContext countForFetchRequest:fetchRequest error:nil];
    	
	return fetchRequest;
}

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

-(MKMapView *)TotalMapView
{
    if(!TotalMapView) {
        TotalMapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
        TotalMapView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    }
    return TotalMapView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

    //
    // set dual view
    //
    self.hidesBottomBarWhenPushed = YES;
    if(self.EntryTag == EntryFromLBS){
    /*
        if(!TotalMapView){
            TotalMapView = [[MKMapView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
            TotalMapView = (MKMapView *)self.view;
        }
        self.view =  [[[MKMapView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame] autorelease];
    */
    }else{
        if(!TotalTableView && [self.view isKindOfClass:[UITableView class]]){
            TotalTableView = (UITableView *)self.view;
        }        
        self.view =  [[[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame] autorelease];
    }
    
    self.tableView.frame = self.view.bounds;
    [self.view addSubview:self.TotalMapView];
     
    self.TotalMapView.frame = self.view.bounds;
    [self.view addSubview:self.TotalTableView];
    
    if(self.EntryTag == EntryFromLBS){
        self.TotalTableView.hidden = YES;
        self.TotalMapView.hidden = NO;          
        self.TotalTableView.delegate = self;       
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"LIST" style:UIBarButtonItemStyleBordered target:self action:@selector(toggleMap)] autorelease];
        
        //
        //  show map init
        //    
        self.TotalMapView.showsUserLocation = YES;
        self.TotalMapView.zoomEnabled = YES;
        self.TotalMapView.multipleTouchEnabled = YES;
        self.TotalMapView.mapType = MKMapTypeStandard;
        self.TotalMapView.scrollEnabled = YES;
        
        //	double X = mapView.userLocation.coordinate.latitude;
        //    double Y = mapView.userLocation.coordinate.longitude;
        //	NSLog(@"X:Y=%f:%f",X , Y);
        
        //取得現在位置
        const MKCoordinateRegion hereIam = (MKCoordinateRegion){
            (CLLocationCoordinate2D) {	25.041349, 121.557802 },
            //mapView.userLocation.location.coordinate,
            (MKCoordinateSpan) { 0.006, 0.006 }};
        [self.TotalMapView setRegion:hereIam animated:YES];

    }else{
        self.TotalMapView.hidden = YES;
        self.TotalTableView.hidden = NO;
        self.TotalMapView.delegate = self;
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"MAP" style:UIBarButtonItemStyleBordered target:self action:@selector(toggleMap)] autorelease];
    }


}

-(void)toggleMap
{

    NSLog(@"is mapview: %i", self.TotalMapView.isHidden);
    
    UIViewAnimationCurve curve = UIViewAnimationCurveEaseInOut;
    [UIView beginAnimations:@"anim" context:NULL];
    [UIView setAnimationCurve:curve];
    [UIView setAnimationDuration:1.0f];
    UIViewAnimationTransition transition = UIViewAnimationTransitionCurlUp;
    
    if(self.TotalMapView.isHidden){
        self.TotalMapView.hidden = NO;
        self.TotalTableView.hidden = YES;
        self.navigationItem.rightBarButtonItem.title = @"LIST";
        TotalMapView.mapType = MKMapTypeStandard;
        TotalMapView.showsUserLocation = YES;
        transition = UIViewAnimationTransitionFlipFromRight;
        
        //
        // show annotation here
        //
        #if 0
        CLLocationCoordinate2D userLoc;
        NSString *lat = @"25.384555";
        NSString *longti = @"120.345234";
        userLoc.latitude = [lat doubleValue];
        userLoc.longitude = [longti doubleValue];
        
        MapAnnotation *nwAnnotation = [[MapAnnotation alloc] initWithTitle:@"Test Map" andCoordinate:userLoc];
        [TotalMapView addAnnotation:nwAnnotation];
        TotalMapView.region = MKCoordinateRegionMakeWithDistance(userLoc, 800, 800);
        #else
                const MKCoordinateRegion hereIam = (MKCoordinateRegion){
            (CLLocationCoordinate2D) {	25.041349, 121.557802 },
            //mapView.userLocation.location.coordinate,
            (MKCoordinateSpan) { 0.006, 0.006 }};
        [self.TotalMapView setRegion:hereIam animated:YES];
        #endif
    }else{
        self.TotalMapView.hidden = YES;
        self.TotalTableView.hidden = NO;
        self.navigationItem.rightBarButtonItem.title = @"MAP";
        transition = UIViewAnimationTransitionFlipFromLeft;
    }
    
    [UIView setAnimationTransition:transition forView:[self view] cache:NO];
    [UIView commitAnimations];    
}


//
//  all about MAP View 
//
+ (NSString *) imageNameForAnnotationType:(MapAnnotationType)aType {    
	return (((NSString *[]){
		[AnnotationOneStarType] = @"bubble02",
		[AnnotationTwoStarsType] = @"bubble05",
		[AnnotationThreeStarsType] = @"bubble07",
		[AnnotationFourStarsType] = @"bubble08",
		[AnnotationFiveStarsType] = @"bubble11",
		[AnnotationUnknownType] = @"bubble10",
		[6] = @"bubble10",
		[7] = @"bubble10",
		[8] = @"bubble10",
		[9] = @"bubble10",
		[10] = @"bubble10",
		[11] = @"bubble10",
		[12] = @"bubble10",
	})[aType]);
}

- (void) mapView:(MKMapView *)aMapView regionDidChangeAnimated:(BOOL)animated {
    
	NSFetchRequest *newFetchRequest = [[self class] fetchRequestInContext:self.managedObjectContext forCoordinateRegion:aMapView.region];
	
	if (self.fetchedResultsController.cacheName)
		[[self.fetchedResultsController class] deleteCacheWithName:self.fetchedResultsController.cacheName];
    
	self.fetchedResultsController.fetchRequest.predicate = newFetchRequest.predicate;
	
	NSError *fetchingError = nil;
	if (![self.fetchedResultsController performFetch:&fetchingError])
		NSLog(@"Error fetching: %@", fetchingError);
	
	[self refreshAnnotations];
	
}

- (void) refreshAnnotations {
    
	NSArray *shownHotels = self.fetchedResultsController.fetchedObjects;
	NSMutableArray *shownAnnotations = [NSMutableArray arrayWithCapacity:[shownHotels count]];
    
	for (unsigned int i = 0; i < [shownHotels count]; i++)
		[shownAnnotations addObject:[NSNull null]];
    
	NSArray *removedAnnotations = [self.TotalMapView.annotations filteredArrayUsingPredicate:[NSPredicate predicateWithBlock: ^ (MapAnnotation *anAnnotation, NSDictionary *bindings) {
		
		if (![anAnnotation isKindOfClass:[MapAnnotation class]])
			return (BOOL)NO;
		
		NSUInteger hotelIndex = [shownHotels indexOfObject:anAnnotation.representedObject];
		if (hotelIndex == NSNotFound)
			return (BOOL)YES;
		
		[shownAnnotations replaceObjectAtIndex:hotelIndex withObject:anAnnotation];
		return (BOOL)NO;
		
	}]];
    
	[self.TotalMapView removeAnnotations:removedAnnotations];
	
	[shownHotels enumerateObjectsUsingBlock: ^ (Hotel *aHotel, NSUInteger idx, BOOL *stop) {
        
		MapAnnotation *annotation = [shownAnnotations objectAtIndex:idx];
		if (![annotation isKindOfClass:[MapAnnotation class]]) {
			annotation = [[[MapAnnotation alloc] init] autorelease];
			[shownAnnotations replaceObjectAtIndex:idx withObject:annotation];
		}
		
		annotation.coordinate = (CLLocationCoordinate2D) {
			[aHotel.latitude doubleValue],
			[aHotel.longitude doubleValue]
		};
		
		annotation.title = aHotel.displayName;
		annotation.type = aHotel.areaCode.integerValue;
		annotation.costStay = aHotel.costStay;
		annotation.costRest = aHotel.costRest;
		annotation.representedObject = aHotel;
        NSLog(@"CostStay = %@",aHotel.costStay);
	}];
	
	[self.TotalMapView addAnnotations:shownAnnotations];
	
}

- (MKAnnotationView *) mapView:(MKMapView *)aMapView viewForAnnotation:(MapAnnotation *)annotation{
    
	if (![annotation isKindOfClass:[MapAnnotation class]]) {
		NSLog(@"%s: Handle user location annotation view", __PRETTY_FUNCTION__);
		return nil;	
	}
	
	NSString * identifier = [[self class] imageNameForAnnotationType:annotation.type];
    
	MKPinAnnotationView *pinView = (MKPinAnnotationView *)[aMapView dequeueReusableAnnotationViewWithIdentifier:identifier];
	
	if (!pinView) {
		
		pinView = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier] autorelease];
		pinView.canShowCallout = YES;
		pinView.calloutOffset = CGPointZero;
		
		UIButton *leftCalloutButton = [UIButton buttonWithType:UIButtonTypeCustom];
		leftCalloutButton.tag = kMapViewController_Accessory_StreetView;
		[leftCalloutButton setImage:[UIImage imageNamed:@"StreetView"] forState:UIControlStateNormal];
		[leftCalloutButton sizeToFit];
		leftCalloutButton.frame = (CGRect){ 0, 0, 25, 25 };
		pinView.leftCalloutAccessoryView = leftCalloutButton;
		
		UIButton *rightCalloutButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
		rightCalloutButton.tag = kMapViewController_Accessory_Disclose;
		pinView.rightCalloutAccessoryView = rightCalloutButton;
        
	}
    
	NSUInteger price = [annotation.costStay unsignedIntValue];
    
	pinView.image = [[UIImage imageNamed:identifier] compositeImageWithOverlayText:
                     [NSString stringWithFormat:!price ?
                      @"未提供" :
                      //[[annotation.costStay stringValue] stringByAppendingFormat:@" 起"]
                      @"NT:%5i",[annotation.costStay intValue] 
                      ]
                     ];
	
	pinView.annotation = annotation;
	
	return pinView;
    
}

- (void) mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)annotationView calloutAccessoryControlTapped:(UIControl *)control{
    
	switch (control.tag) {	
            
		case kMapViewController_Accessory_StreetView: {
			//[self showStreetViewFromAnnotation:annotationView.annotation];
            //[self.navigationController pushViewController:DetailViewController animated:NO];
			break;
		}
            
		case kMapViewController_Accessory_Disclose: {
            
            StreetViewController *streetViewController = [[[StreetViewController alloc] initWithCoordinate:[annotationView.annotation coordinate]] autorelease];
            [self.navigationController pushViewController:streetViewController animated:YES];
			//[self showDetailsViewFromAnnotation:annotationView.annotation];
			break;
		}
            
	}
    
}
//
//  default setting part
//
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = YES;    
    self.navigationController.toolbarHidden = NO;
    CGRect newFrame = self.navigationController.view.frame;
    newFrame.size.height += self.tabBarController.tabBar.frame.size.height;
    self.navigationController.view.frame = newFrame;
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    CGRect newFrame = self.navigationController.view.frame; 
    newFrame.size.height -= self.tabBarController.tabBar.frame.size.height; 
    self.navigationController.view.frame = newFrame;
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.toolbarHidden = YES;
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
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 6;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   // CGFloat height=tableView.rowHeight;
   // if(indexPath.section == 5 )
        return 120;
    
   // return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

#if 0
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
#else
    // custom cell 
    static NSString *CustomCellIdentifier = @"CustomCellIdentifier";
    UITableViewCell *cell = [tableView
							 dequeueReusableCellWithIdentifier: CustomCellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomCell"
													 owner:self options:nil];         
        if ([nib count] > 0) {
            cell = self.tvCell;
        } else {
            NSLog(@"failed to load CustomCell nib file!");
        }
    }

/*
    // Transparent, so we can see the background
    [TableView setBackgroundColor:[UIColor clearColor]];
    [TableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [TableView setIndicatorStyle:UIScrollViewIndicatorStyleWhite];
    //cell.selectionStyle = UITableViewCellSelectionStyleNone; 
*/
        
    NSUInteger row = [indexPath row];
    //NSDictionary *rowData = [self.computers objectAtIndex:row];
    
    [cell setAccessoryType: UITableViewCellAccessoryDisclosureIndicator];
    
    // set back ground pic
    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bar8.png"]];  
    cell.backgroundView.layer.masksToBounds = YES;
    cell.backgroundView.layer.cornerRadius = 20.0;
    
    // set selected cell back ground pic
    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bar8.png"]]; 
    cell.selectedBackgroundView.layer.masksToBounds = YES;
    cell.selectedBackgroundView.layer.cornerRadius = 20.0; 
    cell.selectedBackgroundView.alpha=0.1;
    
    
    // initial load image inside cell
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:KImageTag]; 
    //[imageView setImage: [UIImage imageNamed:[rowData objectForKey:@"Photo"]]];  
    [imageView setImage: [UIImage imageNamed:@"tokyo_hotel.jpg"]];  
    
    // type of image scale
    imageView.contentMode = UIViewContentModeScaleAspectFill;    
    //imageView.autoresizingMask = (  UIViewAutoresizingFlexibleHeight );
    imageView.frame = CGRectMake(14, 14, 94, 94);
    imageView.layer.masksToBounds = YES;
    imageView.layer.cornerRadius = 8.0;     
    
    UILabel *hotelNameLabel = (UILabel *)[cell viewWithTag:kHotelNameValueTag];
    hotelNameLabel.text = @"沒人去時尚旅店HOTEL";//[rowData objectForKey:@"Color"];
	
    UILabel *priceNightLabel = (UILabel *)[cell viewWithTag:kPriceNightValueTag];
    priceNightLabel.text = @"NT: 2300 起 / 過夜";
    UILabel *priceRestLabel = (UILabel *)[cell viewWithTag:kPriceRestValueTag];
    priceRestLabel.text = @"NT: 1200 起 / 休息";
    UILabel *distanceLabel = (UILabel *)[cell viewWithTag:kDistanceValueTag];
    distanceLabel.text = @"0.8 Km";
#endif
    
    // Configure the cell...
    
    /*
    // Configure the cell...
    switch (indexPath.section) {
		case 0:
			cell.textLabel.text = detailHotel.stitle;
			break;
		case 1:
			cell.textLabel.text = detailHotel.CAT2;
			break;
		case 2:
			cell.textLabel.text = detailHotel.address;
			break;
		case 3:
			cell.textLabel.text = detailHotel.MEMO_TEL;
			break;
		case 4:
			cell.textLabel.text = detailHotel.xurl;
			break;
        case 5:
        {
            static weight_cnt=0;
            CGRect imgFrame = CGRectMake(0, 0, 600.0, 200.0);
            UIScrollView *scrollV = [[[UIScrollView alloc] initWithFrame:imgFrame] autorelease];
            
            for(NSString *imageurl in detailHotel.file)
            {
                
                NSURL *url = [NSURL URLWithString:imageurl];
                NSData *data = [NSData dataWithContentsOfURL:url];
                UIImage *image = [[UIImage alloc] initWithData:data];
                UIImageView *imgView = [[UIImageView alloc] initWithImage:image];
                imgView.frame = CGRectMake(0+(200*weight_cnt++),0,200, 200);
                
                scrollV.contentSize = image.size;                
                [scrollV addSubview:imgView];
                //scrollV.minimumZoomScale = 0.3;
                //scrollV.maximumZoomScale = 3.0;
                scrollV.delegate = self;
                [cell addSubview:scrollV];
            }
        }  
            break;
    }
 */
    
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    // Configure the cell...

    NSString *rtnName=nil;
    /*    
    switch (section) {
		case 0:
			rtnName = detailHotel.stitle;
			break;
		case 1:
			rtnName = detailHotel.CAT2;
			break;
		case 2:
			rtnName = detailHotel.address;
			break;
		case 3:
			rtnName = detailHotel.MEMO_TEL;
			break;
		case 4:
			rtnName = detailHotel.xurl;
			break;
        case 5:
            rtnName = @"Image";
            break;
    }
     */    
    return rtnName;

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
     
     /*
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
  
    CellDetailViewController *detailViewController = [[CellDetailViewController alloc] init];
     
    //detailViewController.data = [[data objectAtIndex:section] objectAtIndex:row + 1];
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];     
     */
}

/* All sample may we need
{
    //跳转到打电话页面
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", sb]];
    {
        NSMutableString *phone = [[@"+ 12 34 567 89 01" mutableCopy] autorelease];
            [phone replaceOccurrencesOfString:@" " 
                                    withString:@"" 
                                        options:NSLiteralSearch 
                                        range:NSMakeRange(0, [phone length])];
            [phone replaceOccurrencesOfString:@"(" 
                                    withString:@"" 
                                        options:NSLiteralSearch 
                                        range:NSMakeRange(0, [phone length])];
            [phone replaceOccurrencesOfString:@")" 
                                    withString:@"" 
                                        options:NSLiteralSearch 
                                        range:NSMakeRange(0, [phone length])];
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", phone]];
            [[UIApplication sharedApplication] openURL:url];
    }
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"maps://%@", sb]];
    {
        NSString *title = @"title";
        float latitude = 35.4634;
        float longitude = 9.43425;
        int zoom = 13;
        NSString *stringURL = [NSString stringWithFormat:@"http://maps.google.com/maps?q=%@@%1.6f,%1.6f&z=%d", title, latitude, longitude, zoom];
        NSURL *url = [NSURL URLWithString:stringURL];
        [[UIApplication sharedApplication] openURL:url];
        
        NSString *url = [NSString stringWithFormat:@"http://maps.google.com/maps?saddr=%f,%f&daddr=%f,%f",mapview.userLocation.coordinate.latitude,mapview.userLocation.coordinate.longitude,25.023736, 121.548349];
        
         NSString *urlString = [NSString stringWithFormat: @"maps://?f=q&hl=en&geocode=&q=%@", searchQuery]; 
    }
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"mailto://%@", sb]];
    {
        //These URLs launch Mail and open the compose message controller:
        
        NSString *stringURL = @"mailto:test@example.com";
        NSURL *url = [NSURL URLWithString:stringURL];
        [[UIApplication sharedApplication] openURL:url];
        
        //You can also provide more information, for a customized subject and body texts:
        
        NSString *subject = @"Message subject";
        NSString *body = @"Message body";
        NSString *address = @"test1@akosma.com";
        NSString *cc = @"test2@akosma.com";
        NSString *path = [NSString stringWithFormat:@"mailto:%@?cc=%@&subject=%@&body=%@", address, cc, subject, body];
        NSURL *url = [NSURL URLWithString:[path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [[UIApplication sharedApplication] openURL:url];
        
        //You might also omit some information:
        
        NSString *subject = @"Message subject";
        NSString *path = [NSString stringWithFormat:@"mailto:?subject=%@", subject];
        NSURL *url = [NSURL URLWithString:[path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [[UIApplication sharedApplication] openURL:url];
        //For more complex body texts, you might want to use the CFURLCreateStringByAddingPercentEscapes() function, as explained above in this page.
    }
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto://devprograms@apple.com"]];
    [[UIApplication sharedApplication] openURL:URL]; 

}*/
@end
