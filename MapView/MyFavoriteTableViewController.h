//
//  MyFavoriteTableViewController.h
//  MapView
//
//  Created by App on 2011/10/27.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchHotelQuery.h"
#import "TableViewItem.h"
#import "CombineImages.h"
#import "DetailInfoTableViewController.h"

@interface MyFavoriteTableViewController : UITableViewController<UITableViewDataSource, UITableViewDelegate>

{
    NSMutableArray *dataFavoritesList;
}
@property(nonatomic,retain)	NSMutableArray *dataFavoritesList;
-(void)reflaseDataWithTable;
@end
