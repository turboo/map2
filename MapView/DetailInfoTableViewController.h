//
//  DetailInfoTableViewController.h
//  MapView
//
//  Created by MBP on 10/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "SearchHotelQuery.h"
#import "CombineImages.h"
#import "Hotel.h"
#import "ImageOnURL.h"
#define kNameValueTag   1
#define kColorValueTag  2
#define KScrowViewTag   3

@interface DetailInfoTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{	
  UIScrollView *PicScrollView;
  UITableViewCell *tvCell;
  UIImageView *myImageView;
  UIWebView *detailWebView;
  NSNumber *hotelID;
}

@property (nonatomic, readwrite, retain) UIWebView *detailWebView;
@property (nonatomic, readwrite, assign) NSNumber *hotelID;
@property (nonatomic, retain) IBOutlet UITableViewCell *tvCell;
- (id) initWithHotelID:(NSNumber *)hotelID;

@end
