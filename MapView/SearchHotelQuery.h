//
//  SearchHotelQuery.h
//  Map
//
//  Created by App on 2011/10/24.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Hotel.h"
#import "MADataStore.h"
#import "MapDefines.h"
#import "TableViewItem.h"
#import "MyFavoriteTableViewController.h"
#import "HistoryTableViewController.h"

@interface SearchHotelQuery : NSObject



@property (nonatomic, readwrite, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, readwrite, retain) NSFetchedResultsController *fetchedResultsController;


+ (NSFetchRequest *) fetchRequestInContext:(NSManagedObjectContext *)aContext forPredicateString:(NSString *)PredicateString forSortColumn:(NSString *)SortColumn;

//搜尋結果轉成TableViewItem 的NSMutableArray
-(NSMutableArray *)arrayToTableViewItem:(NSArray *)searchRequestArray;
//列出歷程
-(NSMutableArray *)showHistoryList;
//列出我的最愛
-(NSMutableArray *)showFavoritesList;
//列出符合條件的旅館 
-(NSMutableArray *)inputPredicateShowHotelList:(NSPredicate *)predicateDescription sortWith:(NSArray *)sortDescription;
//用關鍵字列出所有旅館欄位
-(NSMutableArray *)inputKeyWordAndListData:(NSString *)inputHotelName;

//[useDate]欄位全部改Null
-(id)allDeleteuseDate;
//用旅館ID修改[useDate]欄位(日期)
-(id)inputHotelIDAndModifyuseDate:(NSNumber *)HotelID;

//用旅館ID查詢我的最愛欄位輸出我的最愛圖片
-(UIImage *)inputHotelIDAndShowFavorites:(NSNumber *)inputHotelID;
//用旅館ID修改我的最愛欄位輸出我的最愛圖片
-(UIImage *)inputHotelIDAndModifyFavorites:(NSNumber *)HotelID showStatus:(BOOL *)showStatus;

//轉成HotelClass
-(Hotel *)arrayToHotelClass:(NSManagedObject *)inputArray;
//用旅館ID列出所有欄位(true/false)
-(Hotel *)inputHotelIDAndListData:(NSString*)HotelID;
//用旅館ID列出所有欄位(true/false)然後更新歷程欄位
-(Hotel *)inputHotelIDAndListDataAndChange:(NSNumber *)inputHotelID;

@end


