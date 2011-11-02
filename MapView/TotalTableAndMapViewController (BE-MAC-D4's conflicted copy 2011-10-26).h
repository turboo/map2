//
//  TotalTableAndMapViewController.h
//  MapView
//
//  Created by MBP on 10/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreData/CoreData.h>
#import <sqlite3.h>
#import "MADataStore.h"
#import "Hotel.h"
#import "MapAnnotation.h"
#import "MapDefines.h"
#import "MADataStore.h"
#import "CombineImages.h"
#import "StreetView.h"

enum {
    EntryFromLBS=0,
    EntryFromZone,
    
    KImageTag=1,    
    kHotelNameValueTag,    
    kPriceNightValueTag,
    kPriceRestValueTag,
    kDistanceValueTag
};

@interface TotalTableAndMapViewController : UITableViewController<MKMapViewDelegate,UITableViewDataSource, UITableViewDelegate>
{
    UITableView *TotalTableView;
    MKMapView *TotalMapView;
    MADataStore *MAD;
    Hotel *Hotels;
    NSManagedObjectContext *managedObjectContext;
    NSFetchedResultsController *fetchedResultsController;
    NSNumber *EntryTag;
    UITableViewCell *tvCell;
}

- (void) showDetailsViewFromAnnotation:(id<MKAnnotation>)anAnnotation;
- (void) showStreetViewFromAnnotation:(id<MKAnnotation>)anAnnotation;

+ (NSString *) imageNameForAnnotationType:(MapAnnotationType)aType;
+ (NSFetchRequest *) fetchRequestInContext:(NSManagedObjectContext *)aContext forCoordinateRegion:(MKCoordinateRegion)region;

- (void) refreshAnnotations;

@property (nonatomic, readwrite, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, readwrite, retain) NSFetchedResultsController *fetchedResultsController;

@property(nonatomic,retain)MADataStore *MAD;
@property(nonatomic,retain)Hotel *Hotels;
@property(nonatomic,retain)UITableView *TotalTableView;
@property(nonatomic,retain)MKMapView *TotalMapView;
@property(nonatomic,retain)NSNumber *EntryTag;
@property(nonatomic,retain)UITableViewCell *tvCell;

@end
