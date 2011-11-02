//
//  LocationSearchViewController.m
//  MapView
//
//  Created by wan zhen lee on 10/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LocationSearchViewController.h"
#import "TotalTableAndMapViewController.h"

@implementation LocationSearchViewController
@synthesize allLName;

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

-(IBAction)hideImage:(id)sender{
    self.title=@"台北行政區分布圖";
    self.navigationController.title=@"區域查詢";
    [locationIV setImage:nil];
  
}

-(void)pushLBSmap:(id)sender
{
    //
    //  Auto change view frame ...add by EV
    //
    __block void (^noclip)(UIView *) = ^ (UIView *aView) {
        aView.clipsToBounds = NO;
        if (aView.superview)
            noclip(aView.superview);
    };
    noclip(self.view);

    TotalTableAndMapViewController *listAndMapViewController=[[[TotalTableAndMapViewController alloc]init]autorelease];
    listAndMapViewController.EntryTag = EntryFromLBS;
    //[self.tabBarController setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:listAndMapViewController animated:YES];
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
        randomTag=1+random()%12;
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
    if(sender.tag>12)
        titleName = [self.allLName objectAtIndex:sender.tag-12];
    else
        titleName = [self.allLName objectAtIndex:sender.tag];
    
    self.title=titleName;
    self.navigationController.title=@"區域查詢";
    
    [titleName release];
}

-(void)showLocation:(UIButton *)sender{
    NSString *locationName;
    
    if (sender.tag>12)
        locationName=[NSString stringWithFormat:@"%@LbtnD",[self.allLName objectAtIndex:sender.tag-12]];
    else
        locationName=[NSString stringWithFormat:@"%@btnD",[self.allLName objectAtIndex:sender.tag]];
    
    localImage=[UIImage imageNamed:locationName];
    [locationIV setImage:localImage];
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
    
    self.title=@"台北行政區分布圖";
    self.navigationController.title=@"區域查詢";
    localImage=[UIImage imageNamed:@"R"];
    
    self.navigationItem.rightBarButtonItem =[[[UIBarButtonItem alloc]initWithImage:localImage style:UIBarButtonItemStylePlain target:self action:@selector(randlocation:)]autorelease];
    [[UIAccelerometer sharedAccelerometer] setDelegate:self];
    [super viewDidLoad];
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
