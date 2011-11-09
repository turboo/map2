//
//  StreetViewController.m
//  Map
//
//  Created by App on 2011/10/20.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "StreetView.h"

@interface StreetViewController ()
@property (nonatomic, readwrite, retain) UIWebView *webView;
@property (nonatomic, readwrite, assign) CLLocationCoordinate2D initialCoordinate;
@end

@implementation StreetViewController
@synthesize webView, initialCoordinate;

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self.tabBarController.tabBar.hidden = YES;
	return [self initWithCoordinate:(CLLocationCoordinate2D){ 0, 0 }];

}

- (id) initWithCoordinate:(CLLocationCoordinate2D)coordinate title:(NSString *)hotelTitle{

	self = [super initWithNibName:nil bundle:nil];
	if (!self)
		return nil;
	
	self.initialCoordinate = coordinate;
	self.title = hotelTitle;
	return self;

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void) loadView {
	self.webView = [[[UIWebView alloc] initWithFrame:CGRectZero] autorelease];
	self.view = webView;	
}

- (void) viewDidLoad {

	[super viewDidLoad];
  self.title=[NSString stringWithFormat:@"街景圖"];
	NSString *loadedString = [NSString stringWithFormat:
	
		@"<html>"
		@"<head>"
			@"<meta id='viewport' name='viewport' content='width=device-width; initial-scale=1.0; maximum-scale=1.0; user-scalable=0;'>"
			@"<script src='http://maps.google.com/maps/api/js?sensor=false' type='text/javascript'></script>"
		@"</head><body "
			@"onload=\"new google.maps.StreetViewPanorama(document.getElementById('p'),{ position:(new google.maps.LatLng(%f, %f)) });\""
			@"style='padding:0px; margin:0px;'"
		@">"
			@"<div id='p' style='height:460;width:320;'>%@</div>"
		@"</body></html>",
		self.initialCoordinate.latitude,
		self.initialCoordinate.longitude,
		self.title
	];

	[self.webView loadHTMLString:loadedString baseURL:nil];

}

@end
