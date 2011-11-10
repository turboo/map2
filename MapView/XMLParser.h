//
//  XMLParser.h
//  MapView
//
//  Created by wang yuhao on 11/11/10.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMLHotel.h"
#import "MADataStore.h"


@interface XMLParser : NSObject <NSXMLParserDelegate> 
{
	NSMutableString *currentElementValue;
  NSMutableArray *hotels;
  NSManagedObjectContext *managedObjectContext;
  XMLHotel *aHotel ;
}

-(void)updateHotelData;
@property (nonatomic, retain, readwrite) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, assign, readwrite) NSMutableString *currentElementValue;
@property (nonatomic, assign, readwrite) NSMutableArray *hotels;
@property (nonatomic, assign, readwrite) XMLHotel *aHotel;
@end
