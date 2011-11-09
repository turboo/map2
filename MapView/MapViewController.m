//
//  MapViewController.m
//  Map
//
//  Created by Lawrence on 16/07/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MapViewController.h"

static const int kMapViewController_Accessory_StreetView = 1;
static const int kMapViewController_Accessory_Disclose = 2;

//取得現在位置
const MKCoordinateRegion hereIam = (MKCoordinateRegion){
		//(CLLocationCoordinate2D) {	25.041349, 121.557802 },	//忠孝敦化捷運站 需配合0.006,0.006
		(CLLocationCoordinate2D) {25.110603,121.52764},			//天母棒球場附近	需配合0.01, 0.01 
		//mapView.userLocation.location.coordinate,				//手機GPS座標
		(MKCoordinateSpan) { 0.01, 0.01 }};

@implementation MapViewController
@synthesize managedObjectContext, fetchedResultsController;
@synthesize mapView;

/*
+ (NSFetchRequest *) fetchRequestInArray:(NSMutableSet *)dataArray forCoordinateRegion:(MKCoordinateRegion)region {
  NSLog(@"fetchRequestInContext");
	CLLocationDegrees minLat, maxLat, minLng, maxLng;
	minLat = region.center.latitude - region.span.latitudeDelta;
	maxLat = region.center.latitude + region.span.latitudeDelta;
	minLng = region.center.longitude - region.span.longitudeDelta;
	maxLng = region.center.longitude + region.span.longitudeDelta;
	
	      [dataArray filterUsingPredicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"distance < 100"]]];

	
	
	NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
	fetchRequest.entity = [NSEntityDescription entityForName:@"Hotel" inManagedObjectContext:aContext];
	fetchRequest.predicate = [NSPredicate predicateWithFormat:@"(latitude >= %f) AND (latitude <= %f) AND (longitude >= %f) AND longitude <= %f", minLat, maxLat, minLng, maxLng];
	//fetchRequest.sortDescriptors = [NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"modificationDate" ascending:YES],nil];
  fetchRequest.sortDescriptors = [NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"costStay" ascending:NO],nil];
	return fetchRequest;

}
*/
+ (NSFetchRequest *) fetchRequestInContext:(NSManagedObjectContext *)aContext forCoordinateRegion:(MKCoordinateRegion)region {
  NSLog(@"fetchRequestInContext");
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
	return fetchRequest;
}

- (MKMapView *)showMapWithSearchQuery:(NSMutableArray *)resultDataList predicate:(NSPredicate *)predicateDescription{


}

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  NSLog(@"initWithNibName");
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

- (void) viewDidUnload {
  NSLog(@"viewDidUnload");
    [super viewDidUnload];
	//[mapView release];
	
}

- (void) loadView {
  NSLog(@"loadView");
	[super loadView];
	//mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
	//mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
	//mapView.delegate = self;
	//[self.view addSubview:mapView];
}

- (void) dealloc {
	NSLog(@"dealloc");
	[managedObjectContext release];
	[fetchedResultsController release];
	[mapView release];
	[super dealloc];
}

- (void) viewDidLoad {
	NSLog(@"viewDidLoad");
	[super viewDidLoad];
	mapView.showsUserLocation = YES;
	mapView.zoomEnabled = YES;
	mapView.multipleTouchEnabled = YES;
	mapView.mapType = MKMapTypeStandard;
	mapView.scrollEnabled = YES;
	[mapView setRegion:hereIam animated:YES];
}

- (void) mapView:(MKMapView *)aMapView regionDidChangeAnimated:(BOOL)animated {
	NSLog(@"mapView:1");
	NSFetchRequest *newFetchRequest = [[self class] fetchRequestInContext:self.managedObjectContext forCoordinateRegion:aMapView.region];
	if (self.fetchedResultsController.cacheName)
		[[self.fetchedResultsController class] deleteCacheWithName:self.fetchedResultsController.cacheName];
	self.fetchedResultsController.fetchRequest.predicate = newFetchRequest.predicate;
	NSError *fetchingError = nil;
	if (![self.fetchedResultsController performFetch:&fetchingError])
		NSLog(@"Error fetching: %@", fetchingError);
	[self refreshAnnotations:self.fetchedResultsController.fetchedObjects];
}

- (void) refreshAnnotationsWithArray:(NSArray *)shownHotels
{
	NSLog(@"refreshAnnotationsWithArray");
	NSMutableArray *shownAnnotations = [NSMutableArray arrayWithCapacity:[shownHotels count]];
	for (unsigned int i = 0; i < [shownHotels count]; i++)
		[shownAnnotations addObject:[NSNull null]];

	NSArray *removedAnnotations = [self.mapView.annotations filteredArrayUsingPredicate:[NSPredicate predicateWithBlock: ^ (MapAnnotation *anAnnotation, NSDictionary *bindings) {
		if (![anAnnotation isKindOfClass:[MapAnnotation class]])
			return (BOOL)NO;
		NSUInteger hotelIndex = [shownHotels indexOfObject:anAnnotation.representedObject];
		if (hotelIndex == NSNotFound)
			return (BOOL)YES;
		[shownAnnotations replaceObjectAtIndex:hotelIndex withObject:anAnnotation];
		return (BOOL)NO;
	}]];
	[self.mapView removeAnnotations:removedAnnotations];
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
	}];
	
	[self.mapView addAnnotations:shownAnnotations];
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

- (void) mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)annotationView calloutAccessoryControlTapped:(UIControl *)control{
    NSLog(@"mapView:3");
    MapAnnotation *hotelData = [[[MapAnnotation alloc]init ]autorelease];
    hotelData = annotationView.annotation;
    
	switch (control.tag) {	
		case kMapViewController_Accessory_StreetView: {
            StreetViewController *streetViewController = [[[StreetViewController alloc] initWithCoordinate:[hotelData coordinate] title:hotelData.title] autorelease];
            [self.navigationController pushViewController:streetViewController animated:YES]; 
            break;
        }
        case kMapViewController_Accessory_Disclose: {
            DetailInfoTableViewController *DetailsViewController = [[[DetailInfoTableViewController alloc] initWithHotelID:hotelData.odIdentifier ] autorelease];
            [self.navigationController pushViewController:DetailsViewController animated:YES];
            break;
    }
  }
 hotelData = nil;
}



+ (NSString *) imageNameForAnnotationType:(MapAnnotationType)aType {
  NSLog(@"imageNameForAnnotationType");
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


@end
