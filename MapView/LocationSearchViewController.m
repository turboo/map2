//
//  LocationSearchViewController.m
//  MapView
//
//  Created by wan zhen lee on 10/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LocationSearchViewController.h"

@implementation LocationSearchViewController
@synthesize allLName;

- (BOOL) application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    //
    // init CoreDate Database
    //
	if (![MADataStore hasPerformedInitialImport])
		[[MADataStore defaultStore] importData];

    return YES;
}

-(void)dealloc{
    [locationIV release];
    [localImage release];
    [lbtn01 release];
    [lbtn02 release];
    [lbtn03 release];
    [lbtn04 release];
    [lbtn05 release];
    [lbtn06 release];
    [lbtn07 release];
    [lbtn08 release];
    [lbtn09 release];
    [lbtn10 release];
    [lbtn11 release];
    [lbtn12 release];
    [lbtn13 release];
    [lbtn14 release];
    [lbtn15 release];
    [lbtn16 release];
    [lbtn17 release];
    [lbtn18 release];
    [lbtn19 release];
    [lbtn20 release];
    [lbtn21 release];
    [lbtn22 release];
    [lbtn23 release];
    [lbtn24 release];
    [randbtn release];
    [super dealloc];
}


-(void)pushLBSmap:(id)sender
{
    //
    //  Auto change view frame ...add by EV
    //
//    __block void (^noclip)(UIView *) = ^ (UIView *aView) {
//        aView.clipsToBounds = NO;
//        if (aView.superview)
//            noclip(aView.superview);
//    };
//    noclip(self.view);
	MapViewController *mapViewController = [[[MapViewController alloc]init]autorelease];
    [self.navigationController pushViewController:mapViewController animated:YES];
}

-(IBAction)hideImage:(UIButton *)sender{ 
    //
    //  Auto change view frame ...add by EV
    //
    __block void (^noclip)(UIView *) = ^ (UIView *aView) {
        aView.clipsToBounds = NO;
        if (aView.superview)
            noclip(aView.superview);
    };
    
    noclip(self.view);
    self.title=@"台北行政區";
    //self.navigationController.title=@"區域查詢";
    [locationIV setImage:nil];
    
    TotalTableViewController *hotelListTableViewController=[[[TotalTableViewController alloc]init]autorelease];
    if(sender.tag > TAIPEI_AERA_TOTAL)
        hotelListTableViewController.EntryTag = [NSNumber numberWithInt:(sender.tag - TAIPEI_AERA_TOTAL)];
    else
        hotelListTableViewController.EntryTag = [NSNumber numberWithInt:sender.tag];
  
    [self.navigationController pushViewController:hotelListTableViewController animated:YES];
  
  //TotalTableAndMapViewController *listAndMapViewController=[[[TotalTableAndMapViewController alloc]init]autorelease];
  
//  TotalTableViewController *listAndMapViewController=[[[TotalTableViewController alloc]init]autorelease];
//  if(sender.tag > TAIPEI_AERA_TOTAL)
//    listAndMapViewController.EntryTag = [NSNumber numberWithInt:(sender.tag - TAIPEI_AERA_TOTAL)];
//  else
//    listAndMapViewController.EntryTag = [NSNumber numberWithInt:sender.tag];
//  [self.navigationController pushViewController:listAndMapViewController animated:YES];
}

-(IBAction)cancelImage:(id)sender{
  [locationIV setImage:nil];
  self.title=@"台北行政區";
  self.navigationController.title=@"區域查詢";
}

-(IBAction)showImage:(id)sender{
    [locationIV setImage:nil];
    [self showLocation:sender];
    [self showNavTitle:sender];
}

-(IBAction)randlocation:(id)sender{
    static NSInteger randomTag=1;
    static bool randswitch=YES;
    static NSInteger last_result=1;
    
    [locationIV setImage:nil];
    
    randbtn=[[[UIButton alloc]init]autorelease];
    
    if (randswitch == NO)
        randswitch=YES;
    
    if (randswitch) {
        while (last_result == randomTag){
        randomTag= 1+random() % TAIPEI_AERA_TOTAL;
        }
        last_result=randomTag;
        randbtn.tag=randomTag;
        NSLog(@"%d",randbtn.tag);
        [self showLocation:randbtn];
        //[self showNavTitle:randbtn];
        randswitch=NO;
    }
}

-(void)showNavTitle:(UIButton *)sender{
    NSString *titleName;
    if(sender.tag > TAIPEI_AERA_TOTAL)
        titleName = [self.allLName objectAtIndex:(sender.tag-TAIPEI_AERA_TOTAL)];
    else
        titleName = [self.allLName objectAtIndex:sender.tag];
    
    self.title=titleName;
    self.navigationController.title=@"區域查詢";
    
    [titleName release];
}

-(void)showLocation:(UIButton *)sender{

    NSString *locationName;
    if (sender.tag > TAIPEI_AERA_TOTAL)
        locationName=[NSString stringWithFormat:@"%@LbtnD",[self.allLName objectAtIndex:(sender.tag-TAIPEI_AERA_TOTAL)]];
    else
        locationName=[NSString stringWithFormat:@"%@btnD",[self.allLName objectAtIndex:sender.tag]];
    
    localImage=[UIImage imageNamed:locationName];
    [locationIV setImage:localImage];
    //NSLog(@"showLocation %d",sender.tag );
}

-(void)changeview:(id)sender
{
    NSLog(@"ChangeView");
}

-(void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration{
    
    static  NSDate *shakeStart;
    NSDate *now=[[NSDate alloc]init];
    NSDate *checkDate=[[NSDate alloc]initWithTimeInterval:1.5f sinceDate:shakeStart];
    if ([now compare:checkDate] == NSOrderedDescending ||
        shakeStart == nil){
        [shakeStart release];
        shakeStart=[[NSDate alloc]init ];
    }
    
    [now release];
    [checkDate release];
    if(fabsf(acceleration.x)>1.0 &&
       fabsf(acceleration.z)>1.0){
        [self randlocation:randbtn];
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad{
    self.allLName=[[[NSArray alloc]init]autorelease];
    self.allLName=[NSArray arrayWithObjects:
                   [NSNull null],
                   @"北投區",
                   @"士林區",
                   @"內湖區",
                   @"松山區",
                   @"中山區",
                   @"大同區",
                   @"南港區",
                   @"信義區",
                   @"大安區",
                   @"中正區",
                   @"萬華區",
                   @"文山區",
                   nil];
    
    self.title=@"台北行政區";
    
    self.navigationController.navigationBar.tintColor = [UIColor   
                                                         colorWithRed:138.0/255   
                                                         green:177.0/255   
                                                         blue:247.0/255   
                                                         alpha:1]; 
  self.navigationController.toolbar.tintColor = [UIColor   
                                                       colorWithRed:138.0/255   
                                                       green:177.0/255   
                                                       blue:247.0/255   
                                                       alpha:1];
  CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB(); 
  UIImage *imga=[UIImage imageNamed:@"LBSbutton.png"];
  [LBSbtn setImage:imga forState:UIControlStateNormal];
  [LBSbtn.layer setCornerRadius:10]; 
  LBSbtn.layer.borderWidth = 2;
  LBSbtn.layer.masksToBounds=YES;
  //CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
  CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 0.5, 0.5, 0.5, 1 });    
  [LBSbtn.layer setBorderColor:colorref];//边框颜色
  
  UIButton* infoButton = [[UIButton buttonWithType:UIButtonTypeInfoLight]autorelease];  
  [infoButton addTarget:self action:@selector(aboutUS) forControlEvents:UIControlEventTouchUpInside]; 
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:infoButton]; 
    
    //localImage=[UIImage imageNamed:@"R"];
    //self.navigationItem.rightBarButtonItem =[[[UIBarButtonItem alloc]initWithImage:localImage style:UIBarButtonItemStylePlain target:self action:@selector(randlocation:)]autorelease];
    //self.navigationItem.rightBarButtonItem =[[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(aboutUS)]autorelease];

    [[UIAccelerometer sharedAccelerometer] setDelegate:self];
    [super viewDidLoad];
}

-(void)aboutUS
{
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"about us" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"4 people", @" team",nil ] autorelease];
    
    [alert show];
    
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
  if (buttonIndex == 0) {     // and they clicked 1.
    NSLog(@"1 clicked");
  }else if(buttonIndex==1){
    NSLog(@"2 clicked");
  }else if(buttonIndex==2){
    NSLog(@"3 clicked");
  }
}

- (void)viewDidUnload{
    [super viewDidUnload];
    locationIV=nil;
    localImage=nil;
    lbtn01=nil;
    lbtn02=nil;
    lbtn03=nil;
    lbtn04=nil;
    lbtn05=nil;
    lbtn06=nil;
    lbtn07=nil;
    lbtn08=nil;
    lbtn09=nil;
    lbtn10=nil;
    lbtn11=nil;
    lbtn12=nil;
    lbtn13=nil;
    lbtn14=nil;
    lbtn15=nil;
    lbtn16=nil;
    lbtn17=nil;
    lbtn18=nil;
    lbtn19=nil;
    lbtn20=nil;
    lbtn21=nil;
    lbtn22=nil;
    lbtn23=nil;
    lbtn24=nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
