//
//  MyAnnotation.h
//  Map
//
//  Created by Lawrence on 16/07/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

#ifndef __MapAnnotation__
#define __MapAnnotation__

enum {
    AnnotationUnknownType = 0,
    AnnotationOneStarType,
    AnnotationTwoStarsType,
    AnnotationThreeStarsType,
    AnnotationFourStarsType,
    AnnotationFiveStarsType

}; typedef int MapAnnotationType;

#endif

@interface MapAnnotation : NSObject <MKAnnotation>{
    NSString *title;
    NSString *subtitle;
    CLLocationCoordinate2D coordinate;
}


-(id)initWithTitle:(NSString *)ttl andCoordinate: (CLLocationCoordinate2D) c2d;

@property (nonatomic, readwrite, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, readwrite, copy) NSNumber *odIdentifier;
@property (nonatomic, readwrite, copy) NSString *title;
@property (nonatomic, readwrite, copy) NSString *subtitle;
@property (nonatomic, readwrite, copy) NSNumber *costStay;
@property (nonatomic, readwrite, copy) NSNumber *costRest;
@property (nonatomic, readwrite, assign) MapAnnotationType type;

@property (nonatomic, readwrite, retain) id representedObject;

@end
