//
//  ViewController.h
//  MapsearchAfterDetailViewController
//
//  Created by wan zhen lee on 11/2/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Mapkit/Mapkit.h>
#import <MapKit/MKAnnotation.h>
#import <MapKit/MKAnnotationView.h>
@interface DetailMapViewController : UIViewController<MKMapViewDelegate,MKAnnotation>
{
    MKAnnotationView *MKAV;
    
}
@property (retain,nonatomic,readwrite)IBOutlet MKMapView *MKMV;
@property(retain,nonatomic,readwrite)IBOutlet UIButton *LbsBtn;//所在位置
@property(retain,nonatomic,readwrite)IBOutlet UIButton *DtnBtn;//目標位置
@property(retain,nonatomic,readwrite)IBOutlet UIButton *DerBtn;//導覽
-(IBAction)LBSEvent :(id)sender;//所在事件
-(IBAction)DtnEvent :(id)sender;//目標事件
-(IBAction)DerEvent :(id)sender;//導覽事件
- (void)setMapRegionLongitude:(double)Y andLatitude:(double)X withLongitudeSpan:(double)SY andLatitudeSpan:(double)SX;
@end
