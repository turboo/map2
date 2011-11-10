//
//  XMLHotel.h
//  MapView
//
//  Created by wang yuhao on 11/11/10.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMLHotel : NSObject
 
{
  NSString * address;
  NSString * displayName;
  NSString * fax;
  NSString * tel;
  NSNumber * latitude;
  NSNumber * longitude;
  NSDate   * modificationDate;
  NSNumber * odIdentifier;
  NSString * ttIdentifier;
  NSDate   * xmlUpdateDate;
  NSString * imagesArray;
  NSNumber * costStay;
  NSString * xurl;
  NSString * tests;
}
@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * displayName;
@property (nonatomic, retain) NSString * fax;
@property (nonatomic, retain) NSString * tel;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSDate   * modificationDate;
@property (nonatomic, retain) NSNumber * odIdentifier;
@property (nonatomic, retain) NSString * ttIdentifier;
@property (nonatomic, retain) NSDate   * xmlUpdateDate;
@property (nonatomic, retain) NSString * imagesArray;
@property (nonatomic, retain) NSNumber * costStay;
@property (nonatomic, retain) NSString * xurl;
@property (nonatomic, retain) NSString * tests;
@end
