//
//  TableViewItem.m
//  MapView
//
//  Created by App on 2011/10/28.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "TableViewItem.h"

@implementation TableViewItem

@synthesize odIdentifier;
@synthesize coordinate,distance;
@synthesize displayName, tel, address, imagesArray;
@synthesize costRest,costStay;
@synthesize favorites;

- (void) dealloc {

	[odIdentifier release];
	[displayName release];
	[distance release];
	[tel release];
	[address release];
	[costRest release];
	[costStay release];
	[favorites release];
	[imagesArray release];
    
  [super dealloc];
    
}

@end
