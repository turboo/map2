//
//  ViewController.m
//  MapsearchAfterDetailViewController
//
//  Created by wan zhen lee on 11/2/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DetailMapViewController.h"

@implementation DetailMapViewController
@synthesize MKMV;
@synthesize DerBtn,DtnBtn,LbsBtn;//Button
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    
    CLLocationCoordinate2D theCoordinate;
    theCoordinate.latitude =22.3019;
    theCoordinate.longitude=114.1729;
    [MKMV setDelegate: self];
    //[map setCenter:CGPointMake(160, 240)] ;
    [MKMV setMapType: MKMapTypeStandard];
    
    MKCoordinateRegion theRegin;
    
    CLLocationCoordinate2D theCenter;
    theCenter.latitude =24.138923; //=24.148926,120.715542
    theCenter.longitude = 120.725542;
    
    theRegin.center=theCenter;
    MKCoordinateSpan theSpan;
    theSpan.latitudeDelta = 0.01;
    theSpan.longitudeDelta = 0.01;
    
    theRegin.span = theSpan;
    
    [MKMV setRegion:theRegin animated:YES];
    [MKMV regionThatFits:theRegin];
    MKMV.showsUserLocation=YES;
    
    double X = MKMV.centerCoordinate.latitude;
    double Y = MKMV.centerCoordinate.longitude;
    NSLog(@"x=%6f,y=%6f",X,Y);

    MKMV.showsUserLocation = YES;
    MKMV.zoomEnabled = YES;
    MKMV.multipleTouchEnabled = YES;
    MKMV.mapType = MKMapTypeStandard;
    MKMV.scrollEnabled = YES;

    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)LBSEvent:(id)sender {
    //取得現在位置
    double LBSX = MKMV.userLocation.location.coordinate.latitude;
    double LBSY = MKMV.userLocation.location.coordinate.longitude;
    [self setMapRegionLongitude:LBSY andLatitude:LBSX withLongitudeSpan:0.01 andLatitudeSpan:0.01];
}
-(IBAction)DerEvent:(id)sender{

    NSString *urlstr = [NSString stringWithFormat:@"http://maps.google.com/maps?saddr=%f,%f&daddr=%f,%f",
    MKMV.centerCoordinate.latitude,
    MKMV.centerCoordinate.longitude,
    25.023736,
     121.548349
     ];
    NSURL *url = [NSURL URLWithString:urlstr];
    [[UIApplication sharedApplication] openURL:url];
    
}

-(IBAction)DtnEvent:(id)sender{
    double DerX=24.148926;
    double DerY=120.715542;
    [self setMapRegionLongitude:DerY andLatitude:DerX withLongitudeSpan:0.01 andLatitudeSpan:0.01];

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
    [MKMV setRegion:mapRegion];
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

@end
