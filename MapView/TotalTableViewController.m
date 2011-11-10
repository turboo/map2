//
//  TotalTableViewController.m
//  MapView
//
//  Created by MBP on 10/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TotalTableViewController.h"
#import "DetailInfoTableViewController.h"
#import "GameView.h"
#import "asyncimageview.h"
static const int kMapViewController_Accessory_StreetView = 1;
static const int kMapViewController_Accessory_Disclose = 2;

@interface TotalTableViewController () <NSFetchedResultsControllerDelegate>

+ (NSString *) imageNameForAnnotationType:(MapAnnotationType)aType;
+ (NSFetchRequest *) fetchRequestInContext:(NSManagedObjectContext *)aContext forCoordinateRegion:(MKCoordinateRegion)region;
- (void) refreshAnnotations;
@property (nonatomic, readwrite, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, readwrite, retain) NSFetchedResultsController *fetchedResultsController;

@end


@implementation TotalTableViewController

@synthesize hotelSortString;
@synthesize hotelPredicateString;
@synthesize SetSortView,SetFilterView;
@synthesize TotalMapView,TotalTableView;
@synthesize Hotels;
@synthesize MAD;
@synthesize managedObjectContext, fetchedResultsController;
@synthesize EntryTag;
@synthesize tvCell;
@synthesize hotelDataList;
@synthesize resultDataList;
@synthesize bbtnGame,bbtnSort,bbtnFilter,bbtnToMap,bbtnToList,bbtnWhereMe;
@synthesize aryBbtnForTableView,aryBbtnForMapView;
@synthesize dataCountLabel;

- (void) setAnnotationsWithArray:(NSMutableArray *)shownHotels
{
	NSLog(@"setAnnotationsWithArray : %d" , [shownHotels count]);
	SearchHotelQuery *hotelQuery = [[SearchHotelQuery alloc]init];
	[self.TotalMapView addAnnotations:[hotelQuery TableViewItemArrayToMapAnnotation:shownHotels]];
  [hotelQuery release];
}


//  CoreDate init
//
+ (NSFetchRequest *) fetchRequestInContext:(NSManagedObjectContext *)aContext forCoordinateRegion:(MKCoordinateRegion)region {
	CLLocationDegrees minLat, maxLat, minLng, maxLng;
	
	minLat = region.center.latitude - region.span.latitudeDelta;
	maxLat = region.center.latitude + region.span.latitudeDelta;
	minLng = region.center.longitude - region.span.longitudeDelta;
	maxLng = region.center.longitude + region.span.longitudeDelta;
	
	NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
	
	fetchRequest.entity = [NSEntityDescription entityForName:@"Hotel" inManagedObjectContext:aContext];
	
	//fetchRequest.predicate = [NSPredicate predicateWithFormat:@"(latitude >= %f) AND (latitude <= %f) AND (longitude >= %f) AND longitude <= %f", minLat, maxLat, minLng, maxLng];
    
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"(latitude >= 0)"];
    
    fetchRequest.sortDescriptors = [NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"costStay" ascending:NO],nil];
    NSLog(@"fetchRequest");
	//找出的資料筆數
	//NSUInteger numberOfApartments = [aContext countForFetchRequest:fetchRequest error:nil];
	return fetchRequest;
}//
//  PIN about
//

- (void) mapView:(MKMapView *)aMapView regionDidChangeAnimated:(BOOL)animated {
#if 0
	NSFetchRequest *newFetchRequest = [[self class] fetchRequestInContext:self.managedObjectContext forCoordinateRegion:aMapView.region];
	
	if (self.fetchedResultsController.cacheName)
		[[self.fetchedResultsController class] deleteCacheWithName:self.fetchedResultsController.cacheName];
    
	self.fetchedResultsController.fetchRequest.predicate = newFetchRequest.predicate;
	
	NSError *fetchingError = nil;
	if (![self.fetchedResultsController performFetch:&fetchingError])
		NSLog(@"Error fetching: %@", fetchingError);
	
	[self refreshAnnotations];
#endif
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
		
        annotation.odIdentifier = aHotel.odIdentifier;
		annotation.title = aHotel.displayName;
		annotation.type = aHotel.areaCode.integerValue;
		annotation.costStay = aHotel.costStay;
		annotation.costRest = aHotel.costRest;
		annotation.representedObject = aHotel;
        //NSLog(@"CostStay = %@",aHotel.costStay);
	}];
	
	[self.TotalMapView addAnnotations:shownAnnotations];
	
}
- (void) refreshAnnotationsWithArray:(NSMutableArray *)shownHotels
{
	NSLog(@"refreshAnnotationsWithArray : %d" , [shownHotels count]);
	SearchHotelQuery *hotelQuery = [[SearchHotelQuery alloc]init];
	[self.TotalMapView addAnnotations:[hotelQuery TableViewItemArrayToMapAnnotation:shownHotels]];
    [hotelQuery release];
}


- (MKAnnotationView *) mapView:(MKMapView *)aMapView viewForAnnotation:(MapAnnotation *)annotation{
  NSLog(@"mapView:2");
	if (![annotation isKindOfClass:[MapAnnotation class]]) {
		NSLog(@"%s: Handle user location annotation view", __PRETTY_FUNCTION__);
		return nil;	
	}
	NSString * identifier = [[self class] imageNameForAnnotationType:annotation.type];
	MKAnnotationView *pinView = (MKAnnotationView *)[aMapView dequeueReusableAnnotationViewWithIdentifier:identifier];
	if (!pinView) {
		pinView = [[[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier] autorelease];
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
	pinView.image = [[UIImage imageNamed:identifier] compositeImageWithOverlayText:[NSString stringWithFormat:!price ?@"未提供":@"NT:%5i",[annotation.costStay intValue]]];
	pinView.annotation = annotation;
	return pinView;
}

+ (NSString *) imageNameForAnnotationType:(MapAnnotationType)aType {    
	return (((NSString *[]){
		[AnnotationOneStarType] = @"bubble02",
		[AnnotationTwoStarsType] = @"bubble05",
		[AnnotationThreeStarsType] = @"bubble07",
		[AnnotationFourStarsType] = @"bubble08",
		[AnnotationFiveStarsType] = @"bubble06",
		[AnnotationUnknownType] = @"bubble01",
		[6] = @"bubble10",
		[7] = @"bubble10",
		[8] = @"bubble10",
		[9] = @"bubble10",
		[10] = @"bubble10",
		[11] = @"bubble10",
		[12] = @"bubble10",
	})[aType]);
}

- (void) mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)annotationView calloutAccessoryControlTapped:(UIControl *)control{
  MapAnnotation *hotelData = [[[MapAnnotation alloc]init ]autorelease];
  hotelData = annotationView.annotation;

	switch (control.tag) {	
		case kMapViewController_Accessory_StreetView: {
            //[self showStreetViewFromAnnotation:annotationView.annotation];  
#if 0
            __block void (^noclip)(UIView *) = ^ (UIView *aView) {
                aView.clipsToBounds = NO;
                if (aView.superview)
                    noclip(aView.superview);
            };
            noclip(self.view);              
#endif
            StreetViewController *streetViewController = [[[StreetViewController alloc] initWithCoordinate:[hotelData coordinate] title:@"街景圖"] autorelease];
            [self.navigationController pushViewController:streetViewController animated:YES];
            break;
		}
            
		case kMapViewController_Accessory_Disclose: {
            MapAnnotation *hotelData = [[[MapAnnotation alloc]init]autorelease];
            hotelData = annotationView.annotation;
            DetailInfoTableViewController *detailsView = [[[DetailInfoTableViewController alloc]initWithHotelID:hotelData.odIdentifier] autorelease]; 
            
            [self.navigationController pushViewController:detailsView animated:NO];
			break;
		}       
	}
  hotelData = nil;
}

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {

    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (!self) 
        return nil;
    
    self.hidesBottomBarWhenPushed = YES;
    
    return self;
}


- (void) viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    
    self.TotalTableView.clipsToBounds = NO;
    [self.navigationController setToolbarHidden:NO animated:animated];    
    
}

- (void) viewDidAppear:(BOOL)animated {

    self.TotalTableView.clipsToBounds = YES;
    [super viewDidAppear:animated];

}

- (void) viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];

    self.TotalTableView.clipsToBounds = NO;
    [self.navigationController setToolbarHidden:YES animated:animated];

}

- (void) viewDidDisappear:(BOOL)animated {

    self.TotalTableView.clipsToBounds = YES;
    [super viewDidDisappear:animated];
    
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
    }
    NSLog(@" map view : %d",[hotelDataList count]);
 
    TotalMapView.delegate = self;   
    return TotalMapView;
}

- (void)viewDidLoad
{ 
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

    self.managedObjectContext = [[MADataStore defaultStore] disposableMOC]; 
    
    //
    //  ＬＢＳ entry
    //
    self.TotalMapView.showsUserLocation = YES;
    self.TotalMapView.zoomEnabled = YES;
    self.TotalMapView.multipleTouchEnabled = YES;
    self.TotalMapView.mapType = MKMapTypeStandard;
    self.TotalMapView.scrollEnabled = YES;
    [self mapView:TotalMapView regionDidChangeAnimated:YES];     
    
    if(0){//self.EntryTag == TAIPEI_AERA_LBS){

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
        else
            NSLog(@"I GOT fetching data");
        
        //
        //  annotation initial
        //
        MKCoordinateRegion hereIam = (MKCoordinateRegion){
            TotalMapView.userLocation.location.coordinate,	
            (MKCoordinateSpan) { 0.008, 0.008 }
        };
        [TotalMapView setRegion:hereIam animated:YES];
        [TotalMapView regionThatFits:hereIam];
    }

    //
    // set dual view
    // 
    if(!TotalTableView && [self.view isKindOfClass:[UITableView class]]){
        TotalTableView = (UITableView *)self.view;
    }   
    self.view =  [[[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame] autorelease];  
            
    self.TotalTableView.frame = self.view.bounds;
    [self.view addSubview:self.TotalMapView];
     
    self.TotalMapView.frame = self.view.bounds;
    [self.view addSubview:self.TotalTableView];
    
    self.SetSortView.frame = self.view.bounds;
    [self.view addSubview:self.SetSortView];
    self.SetSortView.hidden = YES;
    self.SetSortView.backgroundColor = nil;
    self.SetSortView.opaque = NO;
    
    self.SetFilterView.frame = self.view.bounds;
    [self.view addSubview:self.SetFilterView];
    self.SetFilterView.hidden = YES;
    self.SetFilterView.backgroundColor = nil;
    self.SetFilterView.opaque = NO;
    
    self.view.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
    self.TotalTableView.backgroundColor = nil;
    self.TotalTableView.opaque = NO;
    
    //
    //  set table shadow
    //
    UIColor *fromColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    UIColor *toColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    CGFloat shadowHeight = 4;
    
    UIView *tableBackgroundView = [[[UIView alloc] initWithFrame:(CGRect){ 0, 0, 320, 320 }] autorelease];
    tableBackgroundView.backgroundColor = nil;
    tableBackgroundView.opaque = NO;
    
    [tableBackgroundView addSubview:((^ {
    
        MVGradientView *headerView = [MVGradientView viewFromColor:toColor toColor:fromColor];    
        headerView.frame = (CGRect){ 0, 0, 320, shadowHeight };
        headerView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleBottomMargin;
        return headerView;
            
    })())];    
    [tableBackgroundView addSubview:((^ {
    
        MVGradientView *footerView = [MVGradientView viewFromColor:fromColor toColor:toColor];    
        footerView.frame = (CGRect){ 0, 320 - shadowHeight + 1, 320, shadowHeight - 1 };
        footerView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin;
        return footerView;
            
    })())];
    
    self.TotalTableView.backgroundView = tableBackgroundView;
    
    MVGradientView *headerView = [MVGradientView viewFromColor:fromColor toColor:toColor];    
    headerView.frame = (CGRect){ 0, 0, 320, shadowHeight };
    headerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.TotalTableView.tableHeaderView = headerView;
    
    MVGradientView *footerView = [MVGradientView viewFromColor:toColor toColor:fromColor];    
    footerView.frame = (CGRect){ 0, 0, 320, shadowHeight };
    footerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.TotalTableView.tableFooterView = footerView;
    
    self.TotalTableView.contentInset = (UIEdgeInsets) {
        -1 * shadowHeight,
        0,
        -1 * shadowHeight,
        0
    };
        
    //
    // toolbar button array    
    //
    bbtnToList =[[UIBarButtonItem alloc]
                 initWithImage:[UIImage imageNamed:@"list.png"]
                 style:UIBarButtonItemStyleBordered
                 target:self   
                 action:@selector(toggleMap)]; 
    bbtnToMap = [[UIBarButtonItem alloc]
                 initWithImage:[UIImage imageNamed:@"map.png"]
                 style:UIBarButtonItemStyleBordered 
                 target:self   
                 action:@selector(toggleMap)]; 
    bbtnWhereMe = [[UIBarButtonItem alloc]
                   initWithTitle:@" 現在位置 "   
                   style:UIBarButtonItemStyleBordered  
                   target:self   
                   action:@selector(showWhereAmI)];
    bbtnSort = [[UIBarButtonItem alloc]
                initWithTitle:@" 排序方式 "   
                style:UIBarButtonItemStyleBordered  
                target:self   
                action:@selector(setSortMethod)];  
    bbtnFilter = [[UIBarButtonItem alloc] 
                  initWithTitle:@" 條件過濾 "   
                  style:UIBarButtonItemStyleBordered
                  target:self   
                  action:@selector(setFilterMethod)];  
    bbtnGame = [[UIBarButtonItem alloc] 
                initWithImage:[UIImage imageNamed:@"games.png"]  
                style:UIBarButtonItemStyleBordered
                target:self   
                action:@selector(callGame)]; 
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc]   
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace   
                                      target:nil   
                                      action:nil]; 
    aryBbtnForMapView = [[NSArray alloc]initWithArray:[NSArray arrayWithObjects:bbtnToList, flexibleSpace,bbtnWhereMe,bbtnFilter, flexibleSpace, bbtnGame, nil]];
    aryBbtnForTableView = [[NSArray alloc]initWithArray:[NSArray arrayWithObjects:bbtnToMap, flexibleSpace, bbtnSort,bbtnFilter, flexibleSpace, bbtnGame, nil]];
    
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Park" style:UIBarButtonItemStyleBordered target:self action:@selector(ShowPark)] autorelease];
    
    //
    //  Different entry init
    //
    if(self.EntryTag == TAIPEI_AERA_LBS){
      self.TotalTableView.hidden = YES;
      self.TotalMapView.hidden = !self.TotalTableView.hidden;          
      self.TotalTableView.delegate = self;       
      self.toolbarItems = aryBbtnForMapView; 
    }else{
      self.TotalMapView.hidden = YES;
      self.TotalTableView.hidden = !self.TotalMapView.hidden;
      self.TotalMapView.delegate = self;
      self.toolbarItems = aryBbtnForTableView;
    }

    
	SearchHotelQuery *searchQuery = [[[SearchHotelQuery alloc]init]autorelease];
	//搜尋條件uint
    if(self.EntryTag == TAIPEI_AERA_LBS)
        hotelPredicateString = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"areaCode > 0"]];
    else
        hotelPredicateString = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"areaCode == %@",self.EntryTag]];
	//排序順序
	hotelSortString = [NSArray arrayWithObjects:
                       //[NSSortDescriptor sortDescriptorWithKey:@"distance" ascending:YES],
        [NSSortDescriptor sortDescriptorWithKey:@"favorites" ascending:NO],
        [NSSortDescriptor sortDescriptorWithKey:@"odIdentifier" ascending:YES],nil];
    hotelDataList = [[NSMutableArray alloc]initWithArray:[searchQuery inputPredicateShowHotelList:hotelPredicateString sortWith:hotelSortString]];
    [dataCountLabel setText:[NSString stringWithFormat:@"%d",[hotelDataList count]]];
    resultDataList = [hotelDataList copy];
    
    if(self.EntryTag == TAIPEI_AERA_LBS){
        //
        //  annotation initial
        //
        MKCoordinateRegion hereIam = (MKCoordinateRegion){
            TotalMapView.userLocation.location.coordinate,	
            (MKCoordinateSpan) { 0.008, 0.008 }
        };
        [TotalMapView setRegion:hereIam animated:YES];
        [TotalMapView regionThatFits:hereIam];
        [self reViewData:hotelDataList];
    }
    
    NSLog(@"update resultDataList !!!");
    NSLog(@"1 H:R = %d : %d" ,[hotelDataList count], [resultDataList count]);
}

-(void)showWhereAmI
{
    //  press this button need call TotalMapView show the pin of where Am I    
    MKCoordinateRegion hereIam = (MKCoordinateRegion){
        TotalMapView.userLocation.location.coordinate,	
        (MKCoordinateSpan) { 0.008, 0.008 }
    };
    [TotalMapView setRegion:hereIam animated:YES];
    [TotalMapView regionThatFits:hereIam];
}

-(void)ShowPark
{
    if( self.SetSortView.hidden == NO || self.SetFilterView.hidden == NO)
        return ;
    //  change
    UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"列出公園" message:nil delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
    [alert show];
    [alert release];
}

-(void)reViewData:(NSMutableArray *)myHotelDataList
{
  NSLog(@"reViewData");
  [dataCountLabel setText:[NSString stringWithFormat:@"%d",[myHotelDataList count]]];
  //NSLog(@"MapView:TableView = %@:%@" , (BOOL)self.TotalMapView.hidden,(BOOL)self.TotalTableView.hidden);
  if (self.TotalMapView.hidden)
  {
    NSLog(@"MapView is hidden :%d" , [myHotelDataList count]);
    //[self.TotalTableView beginUpdates];
    [self.TotalTableView reloadData];
    //[self.TotalTableView endUpdates];
  }else{
    NSLog(@"TableView is hidden :%d" , [myHotelDataList count]);
    if ([myHotelDataList count] > 0) { 
      SearchHotelQuery *hotelQuery = [[SearchHotelQuery alloc]init];
      [hotelQuery refreshAnnotationsWithArray:myHotelDataList mapViewController:self.TotalMapView];
      [hotelQuery release];
    }
  }
}
- (void)actionSheet:(UIActionSheet *) modalView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
        {
          //NSLog(@"Stay排序 = %d",[hotelDataList count]);
          [hotelDataList sortUsingDescriptors:[NSArray arrayWithObjects:
          [NSSortDescriptor sortDescriptorWithKey:@"costStay" ascending:YES],
          [NSSortDescriptor sortDescriptorWithKey:@"distance" ascending:YES],
          [NSSortDescriptor sortDescriptorWithKey:@"favorites" ascending:NO],
          [NSSortDescriptor sortDescriptorWithKey:@"odIdentifier" ascending:YES],nil]];
          [self reViewData:hotelDataList];
          break;
        }
        case 1:
        {
          //NSLog(@"Rest排序 = %d",[hotelDataList count]);
          [hotelDataList sortUsingDescriptors:[NSArray arrayWithObjects:
          [NSSortDescriptor sortDescriptorWithKey:@"costRest" ascending:YES],
          [NSSortDescriptor sortDescriptorWithKey:@"distance" ascending:YES],
          [NSSortDescriptor sortDescriptorWithKey:@"favorites" ascending:NO],
          [NSSortDescriptor sortDescriptorWithKey:@"odIdentifier" ascending:YES],nil]];
          [self reViewData:hotelDataList];
          break;
        }
        case 2:
        {
          NSLog(@"distance排序 = %d",[hotelDataList count]);
          [hotelDataList sortUsingDescriptors:[NSArray arrayWithObjects:
          [NSSortDescriptor sortDescriptorWithKey:@"distance" ascending:YES],
          [NSSortDescriptor sortDescriptorWithKey:@"favorites" ascending:NO],
          [NSSortDescriptor sortDescriptorWithKey:@"odIdentifier" ascending:YES],nil]];
          [self reViewData:hotelDataList];
          break;
        }
        default:
            break;
    }
    //[self.TotalTableView reloadData];
    [self reViewData:hotelDataList];
    [self.navigationController setToolbarHidden:NO];    
}

- (IBAction)FilterBtnAction_1:(id)sender{
  
  NSInteger segment = FilterBtn_1.selectedSegmentIndex;  
  // hotelDataList = resultDataList;
   hotelDataList = [resultDataList mutableCopy];

  switch (segment){
    case 0:
      // all
      // 顯示更新資料
      [hotelDataList filterUsingPredicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"costStay >= 0"]]];
      break;
    case 1:
      // ~1499
      // 顯示更新資料
      [hotelDataList filterUsingPredicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"costStay <= 1499"]]];
      break;
    case 2:
      // 顯示更新資料
      [hotelDataList filterUsingPredicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"costStay >= 1500 and costStay <= 2999"]]];
      break;
    case 3:
      [hotelDataList filterUsingPredicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"costStay >= 3000"]]];     
      break;
  } 
  // [self.TotalTableView reloadData];    
  [self reViewData:hotelDataList];                                       
}

- (IBAction)FilterBtnAction_2:(id)sender{
  NSInteger segment = FilterBtn_1.selectedSegmentIndex;
  
  switch (segment){
    case 0:
      // all
      [hotelDataList filterUsingPredicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"costRest >= 0"]]];
      break;
    case 1:
      // 顯示更新資料
      [hotelDataList filterUsingPredicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"costRest <= 999"]]];
      break;
    case 2:
      // 顯示更新資料
      [hotelDataList filterUsingPredicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"costRest >= 1000 and costRest <= 1999"]]];
      break;
    case 3:
      // 顯示更新資料
      [hotelDataList filterUsingPredicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"costRest >= 2000"]]];
      break;
  }       
  // [self.TotalTableView reloadData]; 
  [self reViewData:hotelDataList]; 
}
- (IBAction)FilterBtnAction_3:(id)sender{
  NSInteger segment = FilterBtn_1.selectedSegmentIndex;
  
  switch (segment){
    case 0:
      // 顯示更新資料
      [hotelDataList filterUsingPredicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"distance >= 0"]]];
      break;
    case 1:
      // 顯示更新資料
      [hotelDataList filterUsingPredicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"distance < 100"]]];
      break;
    case 2:
      // 顯示更新資料
      [hotelDataList filterUsingPredicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"distance >= 100 and distance < 500 "]]];
      break;
    case 3:
      // 顯示更新資料
      [hotelDataList filterUsingPredicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"distance >= 500"]]];
      break;
  }  
  [self reViewData:hotelDataList];   
}

-(void)setSortMethod
{
    // press this button call the another view of Sort way

    if(self.SetFilterView.hidden == NO)
        return ;

    UIActionSheet *theActionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"依住宿價格",@"依休息價格",@"依距離", nil];

    [self.navigationController setToolbarHidden:YES];    

    [theActionSheet showInView:self.view];
    [theActionSheet release];

}

-(void)setFilterMethod
{
    // press this button call the another view of Filter way
    
    //  last view index 
    //      0: from map
    //      1: from table
    static int lastView =0;

    int hiddenView = 0;    
    BOOL isCurl = self.SetFilterView.isHidden;
    
    if(self.SetSortView.hidden == NO)
        return ;
    
    CATransition *transition = [CATransition animation];
    transition.type = kCATransitionFade;
    transition.duration = 0.3f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.fillMode = kCAFillModeForwards;
    transition.removedOnCompletion = YES;

    if (isCurl) {
        hiddenView = YES;
        [transition setType:@"pageCurl"];   
        transition.endProgress=0.8;
        lastView = self.TotalMapView.hidden;
        NSLog(@"setFilterMethod1 isCurl");
    } else {
        hiddenView = NO;
        [transition setType:@"pageUnCurl"];
        transition.startProgress=0.2;
        NSLog(@"setFilterMethod2 is NOT Curl");

    }
    
    if(lastView)
        self.TotalTableView.hidden = hiddenView;
    else
        self.TotalMapView.hidden = hiddenView;
    self.SetFilterView.hidden = !hiddenView; 
	//卷的过程完成后停止，并且不从层中移除画
	[transition setFillMode:kCAFillModeForwards];
	[transition setSubtype:kCATransitionFromBottom];
	[transition setRemovedOnCompletion:NO];
    
  isCurl=!isCurl;
	
	//[self.view exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
  [self.view addAnimation:transition forKey:kCATransition];
  [self reViewData:hotelDataList];
}

-(void)callGame
{
/*
    if( self.SetSortView.hidden == NO || self.SetFilterView.hidden == NO)
        return ;
    // call the auto selected game
     UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Enter Game" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
    
    [alert show];
*/
    GameView *gView = [[GameView alloc] init ] ;
    [self.navigationController pushViewController:gView animated:YES];
    
    [gView release];
}

-(void)toggleMap
{
    BOOL mapShowState = NO;
    
    BOOL showingMap = self.TotalMapView.isHidden;
    
    if( self.SetSortView.hidden == NO || self.SetFilterView.hidden == NO)
        return ;
   
    UIViewAnimationCurve curve = UIViewAnimationCurveEaseInOut;
    [UIView beginAnimations:@"anim" context:NULL];
    [UIView setAnimationCurve:curve];
    [UIView setAnimationDuration:0.6f];
    UIViewAnimationTransition transition = UIViewAnimationTransitionCurlUp;
    
    if(self.EntryTag > TAIPEI_AERA_LBS){ 
        TableViewItem *hotelDataListEntity = [hotelDataList objectAtIndex:1];        
        MKCoordinateRegion mapRegion = (MKCoordinateRegion){
            hotelDataListEntity.coordinate,
            (MKCoordinateSpan) { 0.02, 0.02 }};
        
        //將陣列中所有的標籤顯示在地圖上  
        if ([hotelDataList count] > 0)  
            [self refreshAnnotationsWithArray:hotelDataList];          
        //[TotalMapView addAnnotations:hotelDataList];       
        
        [TotalMapView setRegion:mapRegion animated:YES];
        [TotalMapView regionThatFits:mapRegion];
    }

    if (showingMap) {
        //
        // map locate in first hotel location
        //
        mapShowState = NO;
        self.toolbarItems = aryBbtnForMapView; 
        transition = UIViewAnimationTransitionFlipFromRight;
    } else {
        mapShowState = YES;
        self.toolbarItems = aryBbtnForTableView; 
        transition = UIViewAnimationTransitionFlipFromLeft;
    }

    self.TotalMapView.hidden = mapShowState;
    self.TotalTableView.hidden = !mapShowState;
  
    [UIView setAnimationTransition:transition forView:[self view] cache:NO];
    [UIView commitAnimations];
}

//
//  default setting part
//
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
#if 1
    [bbtnToList release];
    [bbtnToMap release];
    [bbtnSort release];
    [bbtnWhereMe release];
    [bbtnFilter release];
    [bbtnGame release];
#endif
    [aryBbtnForTableView release];
    [aryBbtnForMapView release];
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
    if([hotelDataList count]==0)
        return 1;
    else
        return [hotelDataList count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   // CGFloat height=tableView.rowHeight;
   // if(indexPath.section == 5 )
       return 90;
    
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
        
    //NSUInteger row = [indexPath row];
    //NSDictionary *rowData = [self.computers objectAtIndex:row];
    
    [cell setAccessoryType: UITableViewCellAccessoryDisclosureIndicator];
    
    // set back ground pic
    cell.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_bg1.png"]]autorelease];  
    
    // set selected cell back ground pic
   // cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_bg.png"]]; 
    cell.selectedBackgroundView.alpha=0.1;

    if([hotelDataList count]==0){
        cell.selectionStyle  = UITableViewCellSelectionStyleNone;
    
        UIImageView *imageView = (UIImageView *)[cell viewWithTag:KImageTag]; 
        [imageView setImage: [UIImage imageNamed:@"GeneralRoomImg.png"]];
        
        UILabel *hotelNameLabel = (UILabel *)[cell viewWithTag:kHotelNameValueTag];
        hotelNameLabel.text = @"找不到符合的旅館";
        
        UILabel *priceNightLabel = (UILabel *)[cell viewWithTag:kPriceNightValueTag];
        priceNightLabel.text = [NSString stringWithFormat: @"0"];
        
        UILabel *priceRestLabel = (UILabel *)[cell viewWithTag:kPriceRestValueTag];
        priceRestLabel.text = [NSString stringWithFormat: @"0"];
        
        UILabel *distanceLabel = (UILabel *)[cell viewWithTag:kDistanceValueTag];
        distanceLabel.text = [NSString stringWithFormat:@"0"];
        return cell;
    }
    
    //顯示開始
    TableViewItem *hotelDataListEntity = [hotelDataList objectAtIndex:indexPath.row];
    // initial load image inside cell
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:KImageTag]; 
    //[imageView setImage: [UIImage imageNamed:[rowData objectForKey:@"Photo"]]]; 

        
    //顯示圖片  
    //NSLog(@"imagesArray = %@" , hotelDataListEntity.imagesArray);
    //[imageView setImage: [UIImage imageNamed:@"GeneralRoomImg.png"]]; 
    
    // type of image scale
    imageView.contentMode = UIViewContentModeScaleAspectFit;    
    imageView.autoresizingMask = (  UIViewAutoresizingFlexibleHeight );
    imageView.frame = CGRectMake(5, 5, 90, 80);
    imageView.layer.masksToBounds = YES;
    imageView.layer.cornerRadius = 4.0; 
    imageView.backgroundColor = [UIColor blackColor];    
    //
    //  img site parser
    //

    NSArray * imagesArray = [hotelDataListEntity.imagesArray componentsSeparatedByString:@";"];
    ImageOnURL *ImageURL=[[[ImageOnURL alloc]init]autorelease];
    for(NSString* imagesURL in imagesArray){
        imagesURL = [imagesURL stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if ([imagesURL length]>0){
#if 0
            [imageView setImage:[ImageURL sendURLReturnImage:imagesURL]];
#else
            AsyncImageView* asyncImage = [[[AsyncImageView alloc]
                                           initWithFrame:imageView.frame] autorelease];
            asyncImage.tag = 999;
            //      NSURL* url = [imageDownload
            //                    thumbnailURLAtIndex:indexPath.row];
            [asyncImage loadImageFromURL: [NSURL URLWithString:[NSString stringWithFormat:@"%@",imagesURL]]];
            asyncImage.contentMode = UIViewContentModeScaleAspectFill;    
            asyncImage.layer.masksToBounds = YES;
            [imageView addSubview:asyncImage];
#endif
            break;
        }
    }
    imagesArray = nil;  
    
    if(imageView.subviews == nil)
        [imageView setImage: [UIImage imageNamed:@"GeneralRoomImg.png"]]; 

	//顯示旅館名稱 
    UILabel *hotelNameLabel = (UILabel *)[cell viewWithTag:kHotelNameValueTag]; 
    hotelNameLabel.text = hotelDataListEntity.displayName;//[rowData objectForKey:@"Color"]; 
	//過夜價格
    UILabel *priceNightLabel = (UILabel *)[cell viewWithTag:kPriceNightValueTag];
    priceNightLabel.text = [NSString stringWithFormat: @"%5d",[hotelDataListEntity.costStay intValue]];
	//休息價格
    UILabel *priceRestLabel = (UILabel *)[cell viewWithTag:kPriceRestValueTag];
    priceRestLabel.text = [NSString stringWithFormat: @"%5d",[hotelDataListEntity.costRest intValue]];
    //顯示旅館距離
    double_t distance = [hotelDataListEntity.distance doubleValue];
    UILabel *distanceLabel = (UILabel *)[cell viewWithTag:kDistanceValueTag];
    distanceLabel.text = (1/*distance>=1000*/)?[NSString stringWithFormat:@"%4.2f",distance/1000]:[NSString stringWithFormat:@"%3f",distance];
    hotelDataListEntity = nil;
    //顯示結束 
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
    TableViewItem *selItem = [hotelDataList objectAtIndex:indexPath.row];
    DetailInfoTableViewController *detailsView = [[[DetailInfoTableViewController alloc]initWithHotelID:selItem.odIdentifier] autorelease];
    [self.navigationController pushViewController:detailsView animated:YES];
    
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
    
    //MapAnnotation *hotelData = [[[MapAnnotation alloc]init]autorelease];
    //hotelData = annotationView.annotation;
    //DetailInfoTableViewController *DetailInfoTVC = [[[DetailInfoTableViewController alloc]initWithHotelID:hotelData.odIdentifier] autorelease]; 
    //DetailInfoTableViewController *DetailInfoTVC = [[[DetailInfoTableViewController alloc]init]autorelease];
    //[self.navigationController pushViewController:DetailInfoTVC animated:YES];
    
    /*
     NSInteger section = [indexPath section];
     NSInteger row = [indexPath row];
     
     CellDetailViewController *detailViewController = [[CellDetailViewController alloc] init];
     
     //detailViewController.data = [[data objectAtIndex:section] objectAtIndex:row + 1];
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];     
     */
    
}
@end
