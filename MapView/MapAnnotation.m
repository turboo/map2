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


-(id) initWithTitle:(id)ttl andCoordinate:(CLLocationCoordinate2D)c2d
{    
    self = [super init];
    if (self != nil) coordinate = c2d;
    title=ttl;
    return self;
}



- (void) dealloc {
    [odIdentifier release];   
    [title release];
    [subtitle release];
    [costRest release];
    [costStay release];
    [representedObject release];
    
    [title release];
    [super dealloc];
    
}

@end
