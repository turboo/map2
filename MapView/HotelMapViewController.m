//
//  HotelMapViewController.m
//  MapView
//
//  Created by MBP on 11/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HotelMapViewController.h"
#import "MapAnnotation.h"
#import "StreetView.h"

@implementation HotelMapViewController
@synthesize MKMV,hotelLat,hotelLon,hotelName;
@synthesize DerBtn,DtnBtn,LbsBtn;//Button
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [MKMV setDelegate: self];
    //[map setCenter:CGPointMake(160, 240)] ;
    [MKMV setMapType: MKMapTypeStandard];
    MKMV.showsUserLocation = YES;
    MKMV.zoomEnabled = YES;
    MKMV.multipleTouchEnabled = YES;
    MKMV.mapType = MKMapTypeStandard;
    MKMV.scrollEnabled = YES;  
    MKMV.showsUserLocation=YES;   
    
    self.title = hotelName;
    //自行定義設定地圖標籤的函式 
    //宣告一個陣列來存放標籤 
    NSMutableArray *annotations = [[NSMutableArray alloc] init]; 
    
    //隨機設定標籤的緯度 
    CLLocationCoordinate2D pinCenter; 
    pinCenter.latitude = [hotelLat doubleValue]; 
    pinCenter.longitude = [hotelLon doubleValue]; 
    //建立一個地圖標籤並設定內文 
    MapAnnotation *annotation = [[MapAnnotation alloc]initWithTitle:hotelName andCoordinate:pinCenter];
    //將製作好的標籤放入陣列中 
    [annotations addObject:annotation];
    [annotation release]; 
    
    //將陣列中所有的標籤顯示在地圖上 
    [MKMV addAnnotations:annotations]; 
    [annotations release];  
    
    [self setMapRegionLongitude:[hotelLon doubleValue]
                    andLatitude:[hotelLat doubleValue]
              withLongitudeSpan:0.02 andLatitudeSpan:0.02 ];
}
- (MKAnnotationView *) mapView:(MKMapView *)aMapView viewForAnnotation:(MapAnnotation *)annotation{
    
	if (![annotation isKindOfClass:[MapAnnotation class]]) {
		NSLog(@"%s: Handle user location annotation view", __PRETTY_FUNCTION__);
		return nil;	
	}
    
    MKPinAnnotationView *pinView = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"annotation1"]autorelease];
	
    pinView.canShowCallout = YES;
    pinView.animatesDrop = YES;
    
    UIButton *leftCalloutButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftCalloutButton setImage:[UIImage imageNamed:@"StreetView_2"] forState:UIControlStateNormal];
    [leftCalloutButton sizeToFit];
    leftCalloutButton.frame = (CGRect){ 0, 0, 25, 25 };
    pinView.leftCalloutAccessoryView = leftCalloutButton;
	
	pinView.annotation = annotation;
	
	return pinView;    
}

- (void) mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)annotationView calloutAccessoryControlTapped:(UIControl *)control{
    
    StreetViewController *streetViewController = [[[StreetViewController alloc] initWithCoordinate:[annotationView.annotation coordinate] title:@"街景圖"] autorelease];
    [self.navigationController pushViewController:streetViewController animated:YES];
}


- (IBAction)LBSEvent:(id)sender {
    //取得現在位置
    [self setMapRegionLongitude:MKMV.userLocation.location.coordinate.longitude
                    andLatitude:MKMV.userLocation.location.coordinate.latitude
              withLongitudeSpan:0.02 andLatitudeSpan:0.02 ];
}
-(IBAction)DerEvent:(id)sender{
    
    NSString *urlstr = [NSString stringWithFormat:@"http://maps.google.com/maps?saddr=%f,%f&daddr=%f,%f",
                        MKMV.userLocation.location.coordinate.latitude,
                        MKMV.userLocation.location.coordinate.longitude,
                        [hotelLat doubleValue],
                        [hotelLon doubleValue]
                        ];
    NSURL *url = [NSURL URLWithString:urlstr];
    [[UIApplication sharedApplication] openURL:url];
    
}

-(IBAction)DtnEvent:(id)sender{
    [self setMapRegionLongitude:[hotelLon doubleValue] 
                    andLatitude:[hotelLat doubleValue]
              withLongitudeSpan:0.02 
                andLatitudeSpan:0.02];
}

- (void)setMapRegionLongitude:(double)Y andLatitude:(double)X withLongitudeSpan:(double)SY andLatitudeSpan:(double)SX
{
    //設定經緯度
    CLLocationCoordinate2D mapCenter;
    mapCenter.latitude = X;
    mapCenter.longitude = Y;
    
    //Map Zoom設定
    MKCoordinateSpan mapSpan;
    mapSpan.latitudeDelta = SX;
    mapSpan.longitudeDelta = SY;
    
    //設定地圖顯示位置
    MKCoordinateRegion mapRegion;
    mapRegion.center = mapCenter;
    mapRegion.span = mapSpan;
    
    //前往顯示位置
    [MKMV setRegion:mapRegion animated:YES];
    [MKMV regionThatFits:mapRegion];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
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
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

@end
