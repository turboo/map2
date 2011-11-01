//
//  LocationSearchViewController.h
//  MapView
//
//  Created by wan zhen lee on 10/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MADataStore.h"
#import "MapViewController.h"
#import "TotalTableViewController.h"

#define AERA_STRING_1    @"北投區"
#define AERA_STRING_2    @"士林區"
#define AERA_STRING_3    @"內湖區"
#define AERA_STRING_4    @"松山區"
#define AERA_STRING_5    @"中山區"
#define AERA_STRING_6    @"大同區"
#define AERA_STRING_7    @"南港區"
#define AERA_STRING_8    @"信義區"
#define AERA_STRING_9    @"大安區"
#define AERA_STRING_10    @"中正區"
#define AERA_STRING_11    @"萬華區"
#define AERA_STRING_12    @"文山區"

enum {
    TAIPEI_AERA_LBS = 0,
    TAIPEI_AERA_1,      //@"北投區",
    TAIPEI_AERA_2,      //@"士林區",
    TAIPEI_AERA_3,      //@"內湖區",
    TAIPEI_AERA_4,      //@"松山區",
    TAIPEI_AERA_5,      //@"中山區",
    TAIPEI_AERA_6,      //@"大同區",
    TAIPEI_AERA_7,      //@"南港區",
    TAIPEI_AERA_8,      //@"信義區",
    TAIPEI_AERA_9,      //@"大安區",
    TAIPEI_AERA_10,     //@"中正區",
    TAIPEI_AERA_11,     //@"萬華區",
    TAIPEI_AERA_12,     //@"文山區",
    TAIPEI_AERA_TOTAL=TAIPEI_AERA_12
};


@interface LocationSearchViewController : UIViewController<UIAccelerometerDelegate>
{    
    //按鈕
    IBOutlet UIButton *lbtn01;
    IBOutlet UIButton *lbtn02;
    IBOutlet UIButton *lbtn03;
    IBOutlet UIButton *lbtn04;
    IBOutlet UIButton *lbtn05;
    IBOutlet UIButton *lbtn06;
    IBOutlet UIButton *lbtn07;
    IBOutlet UIButton *lbtn08;
    IBOutlet UIButton *lbtn09;
    IBOutlet UIButton *lbtn10;
    IBOutlet UIButton *lbtn11;
    IBOutlet UIButton *lbtn12;
    //地區按鈕
    IBOutlet UIButton *lbtn13;
    IBOutlet UIButton *lbtn14;
    IBOutlet UIButton *lbtn15;
    IBOutlet UIButton *lbtn16;
    IBOutlet UIButton *lbtn17;
    IBOutlet UIButton *lbtn18;
    IBOutlet UIButton *lbtn19;
    IBOutlet UIButton *lbtn20;
    IBOutlet UIButton *lbtn21;
    IBOutlet UIButton *lbtn22;
    IBOutlet UIButton *lbtn23;
    IBOutlet UIButton *lbtn24;
    //亂數按鈕
             UIButton *randbtn;
    //Show Location Image View
    IBOutlet UIImageView *locationIV;
             UIImage *localImage;
             NSArray *allLName;
    //LBS button
    IBOutlet UIButton *LBSbtn;
}

//事件
-(IBAction)hideImage:(UIButton *)sender;
-(IBAction)showImage:(id)sender;
-(IBAction)randlocation:(id)sender;
-(IBAction)pushLBSmap:(id)sender;
-(IBAction)cancelImage:(id)sender;

-(void)changeview:(id)sender;
//show地區
-(void)showLocation:(UIButton *)sender;
//change NavigationController Title
-(void)showNavTitle:(UIButton *)sender;
//晃動偵測
-(void)accelerometer:(UIAccelerometer *)accelerometer 
       didAccelerate:(UIAcceleration *)acceleration;
@property (nonatomic , retain) NSArray *allLName;

@end
