//
//  MapViewController.h
//  Map
//
//  Created by Lawrence on 16/07/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MapAnnotation.h"
#import "MapDefines.h"
#import "Hotel.h"
#import "MADataStore.h"
#import "CombineImages.h"
#import "StreetView.h"
#import "SearchHotelQuery.h"
#import "DetailInfoTableViewController.h"

@interface MapViewController : UIViewController <MKMapViewDelegate>{
}

@property (nonatomic, readonly, retain) MKMapView *mapView;

@end
