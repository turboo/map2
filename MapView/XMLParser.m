//
//  XMLParser.m
//  MapView
//
//  Created by wang yuhao on 11/11/10.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "XMLParser.h"

@implementation XMLParser

@synthesize hotels;
@synthesize aHotel;
@synthesize currentElementValue;
@synthesize managedObjectContext;


- (id)init
{
  NSLog(@"init XML");
  self = [super init];
  if (self) {
    managedObjectContext = [[[MADataStore defaultStore] disposableMOC] retain];
  }
  return self;
}

-(void)updateHotelData
{

  NSLog(@"updateHotelData");
	NSURL *url = [[NSURL alloc] initWithString:@"http://www.taipei.gov.tw/public/ogdi/blob/hotel.xml"];
	NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:url];
	
	//Set delegate
	[xmlParser setDelegate:self];
  
  //Set XMLHotel
  XMLHotel *xmlHotel = [[XMLHotel alloc] init];
  //self.aHotel = xmlHotel;
  [xmlHotel release];
  
	//Start parsing the XML file.
	BOOL success = [xmlParser parse];
	
	if(success)
		NSLog(@"No Errors");
	else
		NSLog(@"Error Error Error!!!");
  [xmlParser release];
  [url release];
}

////用旅館ID修改[useDate]欄位(日期)
//-(id)inputHotelIDAndModifyuseDate:(NSNumber *)inputHotelID
//{
//  NSLog(@"ToDo:搜尋結果轉成Hotel Class");
//  Hotel *hotelList = [[[Hotel alloc] initWithEntity:fetchRequest.entity insertIntoManagedObjectContext:self.managedObjectContext] autorelease];
//	hotelList.address           = [resultDataEntity valueForKey:@"address"];
//  
//  NSLog(@"ToDo:用旅館ID修改[useDate]欄位(日期)%@",inputHotelID);
//	NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
//	fetchRequest.entity = [NSEntityDescription entityForName:@"Hotel" inManagedObjectContext:self.managedObjectContext];
//	fetchRequest.predicate = [NSPredicate predicateWithFormat:@"odIdentifier == %@",inputHotelID];
//  NSArray  *fetchRequestDataArray= [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
//  NSManagedObject *resultDataEntity = [fetchRequestDataArray objectAtIndex:0];
//  //if ([resultDataEntity valueForKey:@"useDate"] == nil)
//  //{
//  [resultDataEntity setValue:[NSDate date] forKey:@"useDate"];
//  NSError *savingError = nil;
//  if (![self.managedObjectContext save:&savingError])
//    NSLog(@"Error saving: %@", savingError);
//  //}else{
//  //  NSLog(@"資料不改變"); xmlUpdateDate
//  //}  
//	return self;
//}


//於遇到XML tag開頭時被呼叫，可取得tag的名稱以及tag裡的attribute
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName 
    attributes:(NSDictionary *)attributeDict {
//  NSLog(@"Element: %@", elementName);
//
//  NSLog(@"didStartElement");
//  NSLog(@"elementName %@", elementName);
	if([elementName isEqualToString:@"CommonFormat"]) {
		//Initialize the array.

	}
	else if([elementName isEqualToString:@"Section"]) {
//		NSLog(@"RowNumber = %d",[[attributeDict objectForKey:@"RowNumber"] integerValue]);
//		//Initialize 
//    NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
//    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"odIdentifier == %d",[[attributeDict objectForKey:@"RowNumber"] integerValue] ];
//    NSArray *fetchRequestDataArray= [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
//		//Extract the attribute here.
//    self.aHotel.odIdentifier = [[attributeDict objectForKey:@"RowNumber"] integerValue];;
//
//    		//NSLog(@"elementName :%@", elementName);
//    
//    [fetchRequestDataArray release];
//    [fetchRequest release];
	}
  	//NSLog(@"Processing Element: %@", elementName);
}

//找到XML tag所包含的內容
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string { 
	if(!currentElementValue) 
		currentElementValue = [[NSMutableString alloc] initWithString:string];
	else
		[currentElementValue appendString:string];
	
  	NSLog(@"Processing Value: %@ (%@)", currentElementValue , string);
}
//於遇到XML tag結尾時被呼叫
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName 
{
  NSLog(@"elementName:%@",elementName);
	if([elementName isEqualToString:@"CommonFormat"]){
		return;
	//There is nothing to do if we encounter the Books element here.
	//If we encounter the Book element howevere, we want to add the book object to the array
	// and release the object.
  }
  else if([elementName isEqualToString:@"Section"]) 
  {
    NSLog(@"  id:%@ name:%@ %@",self.aHotel.odIdentifier,self.aHotel.displayName,self.aHotel.ttIdentifier);
    //NSLog(@"Section end");
	}
  else if([elementName isEqualToString:@"RowNumber"]) 
  {
    self.aHotel.odIdentifier = [NSNumber numberWithInt:[[NSString stringWithString:currentElementValue] intValue]];
	}
  else if([elementName isEqualToString:@"SERIAL_NO"]) 
  {
    [currentElementValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] ;
    self.aHotel.ttIdentifier = [NSString stringWithString:currentElementValue];
	}
  else if([elementName isEqualToString:@"MEMO_TEL"]) 
  {
    [currentElementValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] ;
    self.aHotel.tel = [NSString stringWithString:currentElementValue];
	}
  else if([elementName isEqualToString:@"MEMO_FAX"]) 
  {
    [currentElementValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] ;
    self.aHotel.fax = [NSString stringWithString:currentElementValue];
	}
  else if([elementName isEqualToString:@"MEMO_COST"]) 
  {
    self.aHotel.costStay = [NSNumber numberWithInt:[[NSString stringWithString:currentElementValue] intValue]];
	}
  else if([elementName isEqualToString:@"stitle"]) 
  {
    [currentElementValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] ;
    self.aHotel.displayName = currentElementValue;
    //[aHotel setDisplayName:currentElementValue];
    //NSLog(@"%@ : %@",elementName , currentElementValue);
	}
  else if([elementName isEqualToString:@"address"]) 
  {
    [currentElementValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] ;
    self.aHotel.address = currentElementValue;
	} 
  else if([elementName isEqualToString:@"avEnd"]) 
  {
    // Convert string to date object
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"YYYY/MM/DD"];
    self.aHotel.modificationDate = [dateFormat dateFromString:currentElementValue];
    [dateFormat release];
	}
  else if([elementName isEqualToString:@"xpostDate"]) 
  {
    // Convert string to date object
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"YYYY/MM/DD"];
    self.aHotel.xmlUpdateDate = [dateFormat dateFromString:currentElementValue];
    [dateFormat release];
	}
  else if([elementName isEqualToString:@"xurl"]) 
  {
    [currentElementValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] ;
    self.aHotel.xurl = currentElementValue;
	}
  else if([elementName isEqualToString:@"longitude"]) 
  {
    self.aHotel.longitude = [NSNumber numberWithInt:[[NSString stringWithString:currentElementValue] intValue]];
	}
  else if([elementName isEqualToString:@"latitude"]) 
  {
    self.aHotel.latitude = [NSNumber numberWithInt:[[NSString stringWithString:currentElementValue] intValue]];
	}
	else if ([elementName isEqualToString:@"img"]) 
  { 
    [currentElementValue stringByAppendingString:@";"];
//    [self.aHotel.imagesArray addObject:currentElementValue ];
    self.aHotel.imagesArray = currentElementValue;
	}
	else if ([elementName isEqualToString:@"file"]) 
  {}
	else  
  {}
	[currentElementValue release];
	currentElementValue = nil;
}


- (void) dealloc {
  //[hotels release];
  //[managedObjectContext release];
	[super dealloc];
}

@end

