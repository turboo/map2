//
//  SearchHotelQuery.m
//  Map
//
//  Created by App on 2011/10/24.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//
#import "SearchHotelQuery.h"

@implementation SearchHotelQuery

@synthesize managedObjectContext, fetchedResultsController;

- (NSMutableArray *)refreshAnnotationsWithArray:(NSArray *)shownHotels mapViewController:(MKMapView *)myMapView
{
	NSLog(@"  refreshAnnotationsWithArray : %d",[shownHotels count]);
	NSMutableArray *shownAnnotations = [NSMutableArray arrayWithCapacity:[shownHotels count]];
	for (unsigned int i = 0; i < [shownHotels count]; i++)
		[shownAnnotations addObject:[NSNull null]];
  
	NSArray *removedAnnotations = [myMapView.annotations filteredArrayUsingPredicate:[NSPredicate predicateWithBlock: ^ (MapAnnotation *anAnnotation, NSDictionary *bindings) {
		if (![anAnnotation isKindOfClass:[MapAnnotation class]])
			return (BOOL)NO;
		NSUInteger hotelIndex = [shownHotels indexOfObject:anAnnotation.representedObject];
		if (hotelIndex == NSNotFound)
			return (BOOL)YES;
		[shownAnnotations replaceObjectAtIndex:hotelIndex withObject:anAnnotation];
		return (BOOL)NO;
	}]];
	[myMapView removeAnnotations:removedAnnotations];
	[shownHotels enumerateObjectsUsingBlock: ^ (TableViewItem *aHotel, NSUInteger idx, BOOL *stop) {
		MapAnnotation *annotation = [shownAnnotations objectAtIndex:idx];
		if (![annotation isKindOfClass:[MapAnnotation class]]) {
			annotation = [[[MapAnnotation alloc] init] autorelease];
			[shownAnnotations replaceObjectAtIndex:idx withObject:annotation];
		}
    
		annotation.coordinate = aHotel.coordinate;
		annotation.odIdentifier = aHotel.odIdentifier;
		annotation.title = aHotel.displayName;
		//annotation.type = aHotel.areaCode.integerValue;
    annotation.type = 0;
		annotation.costStay = aHotel.costStay;
		annotation.costRest = aHotel.costRest;
		annotation.representedObject = aHotel;
	}];
	
	[myMapView addAnnotations:shownAnnotations];
}


- (NSMutableArray *)listHotelsWithCoordinateRegion:(MKCoordinateRegion)region 
{
  NSLog(@"listHotelsWithCoordinateRegion");
	CLLocationDegrees minLat, maxLat, minLng, maxLng;
	minLat = region.center.latitude - region.span.latitudeDelta;
	maxLat = region.center.latitude + region.span.latitudeDelta;
	minLng = region.center.longitude - region.span.longitudeDelta;
	maxLng = region.center.longitude + region.span.longitudeDelta;
	NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
	fetchRequest.entity = [NSEntityDescription entityForName:@"Hotel" inManagedObjectContext:self.managedObjectContext];
	fetchRequest.predicate = [NSPredicate predicateWithFormat:@"(latitude >= %f) AND (latitude <= %f) AND (longitude >= %f) AND longitude <= %f", minLat, maxLat, minLng, maxLng];
  fetchRequest.ReturnsObjectsAsFaults=NO;
  NSArray  *searchRequestArray= [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
  return [self arrayToMapAnnotation:searchRequestArray];
  
}

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (!self)
		return nil;
	
	self.managedObjectContext = [[MADataStore defaultStore] disposableMOC];
	self.fetchedResultsController = [[[NSFetchedResultsController alloc] initWithFetchRequest:((^ {
		return [[self class] fetchRequestInContext:self.managedObjectContext forPredicateString:@"" forSortColumn:@"" ];
	})()) managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil] autorelease];
	
	self.fetchedResultsController.delegate = self;
	
	NSError *fetchingError = nil;
	if (![self.fetchedResultsController performFetch:&fetchingError])
		NSLog(@"Error fetching: %@", fetchingError);
  
	return self;
  
}

- (void) dealloc {
  
  //	[persistentStoreCoordinator release];
  //	[managedObjectModel release];
	[super dealloc];
  
}

//- (NSManagedObjectModel *) managedObjectModel {
//
//	if (managedObjectModel)
//		return managedObjectModel;
//		
//	NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"OKHotel" withExtension:@"momd"];
//		
//	managedObjectModel = [[[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL] autorelease];
//	
//	return managedObjectModel;
//
//}



- (id)init
{
  self = [super init];
  if (self) {
    managedObjectContext = [[[MADataStore defaultStore] disposableMOC] retain];
  }
  return self;
}

-(NSMutableArray *)resultSearchInSearch:(NSMutableArray *)arrayContent withPredicate:(NSPredicate *)withPredicate arraySort:(NSArray *)arraySort
{
  NSLog(@"ToDo:用結果再搜尋");
  //arrayContent過濾arrayFilter中的所有item。
  //NSArray *arrayFilter = [NSArray arrayWithObjects:@"abc1", @"abc2", nil];
  //NSArray *arrayContent = [NSArray arrayWithObjects:@"a1", @"abc1", @"abc4", @"abc2", nil];
  //NSPredicate *thePredicate = [NSPredicate predicateWithFormat:@"SELF in %@", arrayFilter];
  //NSPredicate *thePredicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@", arrayFilter];
  NSMutableArray *resultArray =[[[NSMutableArray alloc]init ]autorelease];
  [resultArray sortUsingDescriptors:arraySort];
  [resultArray filterUsingPredicate:withPredicate];
  
  
  return resultArray;
  
  //  fetchRequest.sortDescriptors = [NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"odIdentifier" ascending:YES],nil];
  //  fetchRequest.ReturnsObjectsAsFaults=NO;
  //  NSArray  *searchRequestArray= [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
  //  return [self arrayToTableViewItem:searchRequestArray];
}

//用關鍵字列出所有相關旅館
-(NSMutableArray *)inputKeyWordAndListData:(NSString *)inputpredicate
{
  NSLog(@"ToDo:用關鍵字列出所有相關旅館[%@]",inputpredicate);
	NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
	fetchRequest.entity = [NSEntityDescription entityForName:@"Hotel" inManagedObjectContext:self.managedObjectContext];
	fetchRequest.predicate = [NSPredicate predicateWithFormat:@"%@",inputpredicate];
  fetchRequest.sortDescriptors = [NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"odIdentifier" ascending:YES],nil];
  fetchRequest.ReturnsObjectsAsFaults=NO;
  NSArray  *searchRequestArray= [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
  return [self arrayToTableViewItem:searchRequestArray];
}

//列出歷程
-(NSMutableArray *)showHistoryList
{
  NSLog(@"ToDo:列出歷程");
	NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
	fetchRequest.entity = [NSEntityDescription entityForName:@"Hotel" inManagedObjectContext:self.managedObjectContext];
	fetchRequest.predicate = [NSPredicate predicateWithFormat:@"useDate != null"];
  fetchRequest.sortDescriptors = [NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"odIdentifier" ascending:YES],nil];
  fetchRequest.ReturnsObjectsAsFaults=NO;
  NSArray  *searchRequestArray= [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
  return [self arrayToTableViewItem:searchRequestArray];
}

//列出符合條件的旅館並排序
-(NSMutableArray *)inputPredicateShowHotelList:(NSPredicate *)predicateDescription sortWith:(NSArray *)sortDescription
{
  NSLog(@"ToDo:列出符合條件的旅館 ");
	NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
	fetchRequest.entity = [NSEntityDescription entityForName:@"Hotel" inManagedObjectContext:self.managedObjectContext];
	fetchRequest.predicate = predicateDescription;
	//[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@", predicateString ]  ];
	fetchRequest.sortDescriptors = sortDescription;
	/*
   [NSArray arrayWithObjects:
   [NSSortDescriptor sortDescriptorWithKey:sortString ascending:YES],
   [NSSortDescriptor sortDescriptorWithKey:@"distance" ascending:YES],
   [NSSortDescriptor sortDescriptorWithKey:@"favorites" ascending:NO],
   [NSSortDescriptor sortDescriptorWithKey:@"odIdentifier" ascending:YES],
   nil];
   */
  fetchRequest.ReturnsObjectsAsFaults=NO;
  NSArray  *searchRequestArray= [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
  return [self arrayToTableViewItem:searchRequestArray];
}
//列出我的最愛
-(NSMutableArray *)showFavoritesList
{
  NSLog(@"ToDo:列出我的最愛");
	NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
	fetchRequest.entity = [NSEntityDescription entityForName:@"Hotel" inManagedObjectContext:self.managedObjectContext];
	fetchRequest.predicate = [NSPredicate predicateWithFormat:@"favorites > 0"];
  fetchRequest.sortDescriptors = [NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"odIdentifier" ascending:YES],nil];
  fetchRequest.ReturnsObjectsAsFaults=NO;
  NSArray  *searchRequestArray= [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
  return [self arrayToTableViewItem:searchRequestArray];
}

//TableViewItem轉成MapAnnotation 
-(NSMutableArray *)TableViewItemArrayToMapAnnotation:(NSMutableArray *)TableViewItemArray 
{ 
  NSLog(@"ToDo:TableViewItemArray轉成MapAnnotation:%d",[TableViewItemArray count]); 
  NSMutableArray *mapAnnotationArray = [[NSMutableArray alloc]init];
  for (int i=0; i<[TableViewItemArray count]; i++) {
    TableViewItem *aHotelData = [TableViewItemArray objectAtIndex:i];    
    MapAnnotation *dataList = [[MapAnnotation alloc]init];
		dataList.coordinate = aHotelData.coordinate;
    dataList.odIdentifier= aHotelData.odIdentifier;
		dataList.title = aHotelData.displayName;
		dataList.costStay = aHotelData.costStay;
		dataList.costRest = aHotelData.costRest;
    dataList.type = 0;
    if (aHotelData.distance.intValue>1000)
      dataList.subtitle = [NSString stringWithFormat:@"%4.2f Km",aHotelData.distance.floatValue/1000];
    else
      dataList.subtitle = [NSString stringWithFormat:@"%4d m",aHotelData.distance.intValue];
    dataList.representedObject = aHotelData;
    [mapAnnotationArray addObject:dataList];
    [dataList release];
    [aHotelData release]; 
  }
  return mapAnnotationArray;
}

//搜尋結果searchResultArray轉成MapAnnotation 
-(NSMutableArray *)searchResultArrayToMapAnnotation:(NSMutableArray *)searchRequestArray 
{ 
  NSLog(@"ToDo:搜尋結果searchResultArray轉成MapAnnotation:%d",[searchRequestArray count]); 
  NSMutableArray *mapAnnotationArray = [[NSMutableArray alloc]init];
  
  for (int i=0; i<[searchRequestArray count]; i++) {
    NSManagedObject *resultDataEntity = [searchRequestArray objectAtIndex:i];    
    MapAnnotation *dataList = [[MapAnnotation alloc]init];
		dataList.coordinate = (CLLocationCoordinate2D) {
			[[resultDataEntity valueForKey:@"latitude"] doubleValue],
			[[resultDataEntity valueForKey:@"longitude"] doubleValue]
		};
    dataList.odIdentifier= [resultDataEntity valueForKey:@"odIdentifier"];
		dataList.title = [resultDataEntity valueForKey:@"displayName"];
		dataList.costStay = [resultDataEntity valueForKey:@"costStay"];
		dataList.costRest = [resultDataEntity valueForKey:@"costRest"];
    dataList.type = 0;
    if ([[resultDataEntity valueForKey:@"distance"]intValue]>1000)
      dataList.subtitle = [NSString stringWithFormat:@"%4.2f Km",[[resultDataEntity valueForKey:@"distance"]floatValue]/1000];
    else
      dataList.subtitle = [NSString stringWithFormat:@"%4d m",[[resultDataEntity valueForKey:@"distance"]intValue]];
    dataList.representedObject = resultDataEntity;
    [mapAnnotationArray addObject:dataList];
    [dataList release];
    [resultDataEntity release]; 
  }
  return mapAnnotationArray;
}

//搜尋結果轉成TableViewItem 的NSMutableArray
-(NSMutableArray *)arrayToTableViewItem:(NSArray *)searchRequestArray 
{ 
  NSLog(@"ToDo:搜尋結果轉成TableViewItem Class的NSMutableArray:%d",[searchRequestArray count]); 
  NSMutableArray *searchResultArray = [[NSMutableArray alloc]init];
	NSArray *imageArray = [[[NSArray alloc]init]autorelease];
  for (int i=0; i<[searchRequestArray count]; i++) {
    NSManagedObject *resultDataEntity = [searchRequestArray objectAtIndex:i];    
    TableViewItem *dataList = [[[TableViewItem alloc]init]autorelease];
		dataList.coordinate = (CLLocationCoordinate2D) {
			[[resultDataEntity valueForKey:@"latitude"] doubleValue],
			[[resultDataEntity valueForKey:@"longitude"] doubleValue]
		};
		dataList.odIdentifier = [resultDataEntity valueForKey:@"odIdentifier"];
		dataList.displayName = [resultDataEntity valueForKey:@"displayName"];
		dataList.distance = [NSNumber numberWithDouble:MapDistanceBetweenUserLocationAndCoordinates(dataList.coordinate)];
		dataList.tel= [resultDataEntity valueForKey:@"tel"];
		dataList.address = [resultDataEntity valueForKey:@"address"];
		dataList.costStay = [resultDataEntity valueForKey:@"costStay"];
		dataList.costRest = [resultDataEntity valueForKey:@"costRest"];
    
		imageArray = [[resultDataEntity valueForKey:@"imagesArray"] componentsSeparatedByString:@";"];
    
		if ([[imageArray objectAtIndex:0] length] > 0)
			dataList.imagesArray = [[imageArray objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		else
			dataList.imagesArray = [NSString stringWithFormat:@"tokyo_hotel.jpg"];
    [searchResultArray addObject:dataList];
  }
	imageArray = nil;
	[imageArray release];
  return searchResultArray;
}

//搜尋結果轉成Hotel Class
-(Hotel *)arrayToHotelClass:(NSFetchRequest *)fetchRequest resultDataEntity:(NSManagedObject *) resultDataEntity
{
  NSLog(@"ToDo:搜尋結果轉成Hotel Class");
  Hotel *hotelList = [[[Hotel alloc] initWithEntity:fetchRequest.entity insertIntoManagedObjectContext:self.managedObjectContext] autorelease];
	hotelList.address           = [resultDataEntity valueForKey:@"address"];
	hotelList.areaCode          = [resultDataEntity valueForKey:@"areaCode"];
	hotelList.areaName          = [resultDataEntity valueForKey:@"areaName"];
	hotelList.descriptionHTML   = [resultDataEntity valueForKey:@"descriptionHTML"];
	hotelList.displayName       = [resultDataEntity valueForKey:@"displayName"];
	hotelList.email             = [resultDataEntity valueForKey:@"email"];
	hotelList.fax               = [resultDataEntity valueForKey:@"fax"];
	hotelList.tel               = [resultDataEntity valueForKey:@"tel"];
	hotelList.latitude          = [resultDataEntity valueForKey:@"latitude"];
	hotelList.longitude         = [resultDataEntity valueForKey:@"longitude"];
	hotelList.modificationDate	= [resultDataEntity valueForKey:@"modificationDate"];
	hotelList.odIdentifier      = [resultDataEntity valueForKey:@"odIdentifier"];
	hotelList.ttIdentifier      = [resultDataEntity valueForKey:@"ttIdentifier"];
	hotelList.hotelType         = [resultDataEntity valueForKey:@"hotelType"];
	hotelList.xmlUpdateDate     = [resultDataEntity valueForKey:@"xmlUpdateDate"];
	hotelList.imagesArray       = [resultDataEntity valueForKey:@"imagesArray"];
	hotelList.favorites         = [resultDataEntity valueForKey:@"favorites"];
	hotelList.costStay          = [resultDataEntity valueForKey:@"costStay"];
	hotelList.costRest          = [resultDataEntity valueForKey:@"costRest"];
	hotelList.useDate           = [resultDataEntity valueForKey:@"useDate"];
  hotelList.xurl              = [resultDataEntity valueForKey:@"xurl"];
  return hotelList;
}

//用旅館ID修改[useDate]欄位(日期)
-(id)inputHotelIDAndModifyuseDate:(NSNumber *)inputHotelID
{
  NSLog(@"ToDo:用旅館ID修改[useDate]欄位(日期)%@",inputHotelID);
	NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
	fetchRequest.entity = [NSEntityDescription entityForName:@"Hotel" inManagedObjectContext:self.managedObjectContext];
	fetchRequest.predicate = [NSPredicate predicateWithFormat:@"odIdentifier == %@",inputHotelID];
  NSArray  *fetchRequestDataArray= [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
  NSManagedObject *resultDataEntity = [fetchRequestDataArray objectAtIndex:0];
  //if ([resultDataEntity valueForKey:@"useDate"] == nil)
  //{
  [resultDataEntity setValue:[NSDate date] forKey:@"useDate"];
  NSError *savingError = nil;
  if (![self.managedObjectContext save:&savingError])
    NSLog(@"Error saving: %@", savingError);
  //}else{
  //  NSLog(@"資料不改變");
  //}  
	return self;
}

//[useDate]欄位全部改Null
-(id)allDeleteuseDate
{
  NSLog(@"ToDo:[useDate]欄位全部改Null");
	NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
	fetchRequest.entity = [NSEntityDescription entityForName:@"Hotel" inManagedObjectContext:self.managedObjectContext];
	fetchRequest.predicate = [NSPredicate predicateWithFormat:@"useDate != null"];
  fetchRequest.ReturnsObjectsAsFaults=NO;
  NSArray  *searchRequestArray= [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
	NSLog(@"allDeleteuseDate的資料筆數= %d",[searchRequestArray count]);
  for (int i=0; i<[searchRequestArray count]; i++) {
    NSManagedObject *resultDataEntity = [searchRequestArray objectAtIndex:i];    
    [resultDataEntity setValue:nil forKey:@"useDate"];
  }
  NSError *savingError = nil;
  if (![self.managedObjectContext save:&savingError])
    NSLog(@"Error saving: %@", savingError);
  
  return self;
}



//用旅館ID查詢我的最愛欄位輸出我的最愛圖片
-(UIImage *)inputHotelIDAndShowFavorites:(NSNumber *)inputHotelID
{
  NSLog(@"ToDo:用旅館查我的最愛欄位輸出我的最愛圖片 %@",inputHotelID);
	NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
	fetchRequest.entity = [NSEntityDescription entityForName:@"Hotel" inManagedObjectContext:self.managedObjectContext];
	fetchRequest.predicate = [NSPredicate predicateWithFormat:@"odIdentifier == %@",inputHotelID];
  NSArray  *fetchRequestDataArray= [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
  NSManagedObject *resultDataEntity = [fetchRequestDataArray objectAtIndex:0];
  return [UIImage imageNamed:[[resultDataEntity valueForKey:@"favorites"] intValue]>0?@"myFavorite":@"myFavorite_empty" ];
}

//用旅館ID 變更我的最愛欄位 並輸出我的最愛圖片
-(UIImage *)inputHotelIDAndModifyFavorites:(NSNumber *)inputHotelID showStatus:(BOOL *)showStatus
{
  NSLog(@"ToDo://用旅館ID查詢我的最愛欄位輸出我的最愛圖片 %@",inputHotelID);
  UIImage *imgFavorite = [[[UIImage alloc]init]autorelease];
	NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
	fetchRequest.entity = [NSEntityDescription entityForName:@"Hotel" inManagedObjectContext:self.managedObjectContext];
	fetchRequest.predicate = [NSPredicate predicateWithFormat:@"odIdentifier == %@",inputHotelID];
  NSArray  *fetchRequestDataArray= [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
  if ([fetchRequestDataArray count]>0){
    NSManagedObject *resultDataEntity = [fetchRequestDataArray objectAtIndex:0];
    if ([[resultDataEntity valueForKey:@"favorites"]intValue] > 0)
    {
      [resultDataEntity setValue:[NSNumber numberWithInt:0] forKey:@"favorites"];
      imgFavorite = [UIImage imageNamed:@"myFavorite_empty"];
      NSLog(@"myFavorite_empty");
    }else{
      [resultDataEntity setValue:[NSNumber numberWithInt:1] forKey:@"favorites"];
      imgFavorite = [UIImage imageNamed:@"myFavorite"];
      NSLog(@"myFavorite");
    }
    
    NSError *savingError = nil;
    if (![self.managedObjectContext save:&savingError])
      NSLog(@"Error saving: %@", savingError);
  }
  if (showStatus) 
    return imgFavorite;
  else
    return nil;
}

//用旅館ID列出所有欄位(true/false)
-(Hotel *)inputHotelIDAndListData:(NSNumber *)inputHotelID
{
  NSLog(@"ToDo:用旅館ID列出所有欄位(true/false)");
	NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
	fetchRequest.entity = [NSEntityDescription entityForName:@"Hotel" inManagedObjectContext:self.managedObjectContext];
	fetchRequest.predicate = [NSPredicate predicateWithFormat:@"odIdentifier == %@",inputHotelID];   
  NSArray  *fetchRequestDataArray= [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
  NSManagedObject *resultDataEntity = [fetchRequestDataArray objectAtIndex:0];
  return [self arrayToHotelClass:fetchRequest resultDataEntity:resultDataEntity];
}

//用旅館ID列出所有欄位(true/false)然後更新歷程欄位
-(Hotel *)inputHotelIDAndListDataAndChange:(NSNumber *)inputHotelID
{
  NSLog(@"ToDo:用旅館ID列出所有欄位(true/false)然後更新歷程欄位");
	NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
	fetchRequest.entity = [NSEntityDescription entityForName:@"Hotel" inManagedObjectContext:self.managedObjectContext];
	fetchRequest.predicate = [NSPredicate predicateWithFormat:@"odIdentifier == %@",inputHotelID];   
  NSArray  *fetchRequestDataArray= [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
  NSLog(@"inputHotelID == %@",inputHotelID);
  NSManagedObject *resultDataEntity = [fetchRequestDataArray objectAtIndex:0];
  //更新為現在時間
  [resultDataEntity setValue:[NSDate date] forKey:@"useDate"];
  //[resultDataEntity setValue:[NSNumber numberWithInt:1] forKey:@"favorites"];	
  NSError *savingError = nil;
	if (![self.managedObjectContext save:&savingError])
		NSLog(@"Error saving: %@", savingError);
  return [self arrayToHotelClass:fetchRequest resultDataEntity:resultDataEntity];
}

-(void)test{
  //  ，NSDictionary，NSValue，NSEnumerator基本操作
  //  NSEnumerator *enumerator = [myMutableDict keyEnumerator];
  //  id aKey = nil;
  //  while ( (aKey = [enumerator nextObject]) != nil) {
  //    id value = [myMutableDict objectForKey:anObject];
  //    NSLog(@"%@: %@", aKey, value);
  //  }
  //  NSMutableDictionary *glossary = [NSMutableDictionary dictionary];
  //  //Store three entries in the glossary
  //  [glossary setObject: @"A class defined so other classes can inherit from it"
  //               forkey: @"abstract class"];
  //  [glossary setObject: @"To implement all the methods defined in a protocol"
  //               forkey: @"adopt"];
  //  [glossary setObject: @"Storing an object for later use"
  //               forkey: @"archiving"];
  //  for (NSString *key in glossary){
  //    NSLog(@"%@:%@", key, [glossary objectForKey: key]);
  //  }
  //
  //NSMutableSet *useDate = [person mutableSetValueForKey:@"children"]; //查询，可修改
  //[children addObject:child];
  //[children removeObject:childToBeRemoved];
  //[[children managedObjectContext] deleteObject:childToBeRemoved]; //真正的删除
  //NSSet *children = [person valueForKey:@"children"]; //查询，不可修改
  //for (NSManagedObject *oneChild in children) {
  //// do something
  //
  //
}

@end

