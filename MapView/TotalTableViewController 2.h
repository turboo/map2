//
//  TotalTableViewController.h
//  MapView
//
//  Created by MBP on 10/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreData/CoreData.h>
#import <QuartzCore/QuartzCore.h>
#import <sqlite3.h>
#import "CombineImages.h"
#import "DetailInfoTableViewController.h"
#import "Hotel.h"
#import "LocationSearchViewController.h"
#import "MapAnnotation.h"
#import "MapDefines.h"
#import "MADataStore.h"
#import "MVGradientView.h"
#import "StreetView.h"
#import "SetSortMethod.h"
#import "SetFilterMethod.h"
#import "SearchHotelQuery.h"
#import "TableViewItem.h"

enum {    
    KImageTag=1,    
    kHotelNameValueTag,    
    kPriceNightValueTag,
    kPriceRestValueTag,
    kDistanceValueTag
};

// use UITabelViewController can't change style？？？？？
@interface TotalTableViewController : UIViewController<MKMapViewDelegate,UITableViewDataSource, UITableViewDelegate,UIActionSheetDelegate>
{
    UITableView *TotalTableView;
    MKMapView *TotalMapView;
    
    IBOutlet UIView *SetSortView;
    IBOutlet UIView *SetFilterView;
    
    MADataStore *MAD;
    Hotel *Hotels;
    NSManagedObjectContext *managedObjectContext;
    NSFetchedResultsController *fetchedResultsController;
    UITableViewCell *tvCell;
    NSNumber *EntryTag;  

    UIBarButtonItem *bbtnToList;
    UIBarButtonItem *bbtnToMap;
    UIBarButtonItem *bbtnSort;
    UIBarButtonItem *bbtnWhereMe;
    UIBarButtonItem *bbtnFilter;
    UIBarButtonItem *bbtnGame;
    NSArray *aryBbtnForTableView;
    NSArray *aryBbtnForMapView;
    NSMutableArray *hotelDataList;
	NSArray *hotelSortString;
	NSPredicate *hotelPredicateString;
}


- (void) showDetailsViewFromAnnotation:(id<MKAnnotation>)anAnnotation;
- (void) showStreetViewFromAnnotation:(id<MKAnnotation>)anAnnotation;

@property(nonatomic, retain)	NSMutableArray *hotelDataList;
@property(nonatomic,retain)		MADataStore *MAD;
@property(nonatomic,retain)		Hotel *Hotels;
@property(nonatomic,retain) 	NSArray *hotelSortString;
@property(nonatomic,retain) 	NSPredicate *hotelPredicateString;

@property(nonatomic,retain)		IBOutlet UIView *SetSortView;
@property(nonatomic,retain)		IBOutlet UIView *SetFilterView;

@property(nonatomic,retain)UITableView *TotalTableView;
@property(nonatomic,retain)MKMapView *TotalMapView;
@property(nonatomic,retain)NSNumber *EntryTag;
@property(nonatomic,retain)UITableViewCell *tvCell;

@property(nonatomic,retain)UIBarButtonItem *bbtnToList;
@property(nonatomic,retain)UIBarButtonItem *bbtnToMap;
@property(nonatomic,retain)UIBarButtonItem *bbtnSort;
@property(nonatomic,retain)UIBarButtonItem *bbtnWhereMe;
@property(nonatomic,retain)UIBarButtonItem *bbtnFilter;
@property(nonatomic,retain)UIBarButtonItem *bbtnGame;
@property(nonatomic,retain)NSArray *aryBbtnForTableView;
@property(nonatomic,retain)NSArray *aryBbtnForMapView;

@end
