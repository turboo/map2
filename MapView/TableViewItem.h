//
//  TableViewItem.h
//  MapView
//
//  Created by App on 2011/10/28.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface TableViewItem : NSObject <MKAnnotation>

@property (nonatomic, readwrite, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, readwrite, copy) NSNumber *odIdentifier;
@property (nonatomic, readwrite, copy) NSString *displayName;
@property (nonatomic, readwrite, copy) NSString *tel;
@property (nonatomic, readwrite, copy) NSNumber *distance;
@property (nonatomic, readwrite, copy) NSNumber *address;
@property (nonatomic, readwrite, copy) NSNumber *costStay;
@property (nonatomic, readwrite, copy) NSNumber *costRest;
@property (nonatomic, readwrite, copy) NSString *imagesArray;
@property (nonatomic, readwrite, copy) NSNumber *favorites;
@end