//
//  MyAnnotation.m
//  Map
//
//  Created by Lawrence on 16/07/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MapAnnotation.h"

@implementation MapAnnotation

@synthesize odIdentifier;
@synthesize coordinate, title, subtitle, type, representedObject;
@synthesize costRest,costStay;

@synthesize barTitle,mapCoordinate;

-(id) initWithTitle:(id)ttl andCoordinate:(CLLocationCoordinate2D)c2d
{
    [super init];
    barTitle=ttl;
    mapCoordinate =c2d;
    return self;
}



- (void) dealloc {
    [odIdentifier release];   
    [title release];
    [subtitle release];
    [costRest release];
    [costStay release];
    [representedObject release];
    
    [barTitle release];
    [super dealloc];
    
}

@end
