//
//  MainNavigationController.m
//  MapView
//
//  Created by wan zhen lee on 10/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MainNavigationController.h"
#import "LocationSearchViewController.h"
#import "MapViewAppDelegate.m"
@implementation MainNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        LocationSearchViewController *LSVC=[[[LocationSearchViewController alloc] initWithNibName:@"Myviewcontroller" bundle:nil]autorelease];
        UINavigationController *navC=[[[UINavigationController alloc] initWithRootViewController:LSVC]autorelease];
        MapViewAppDelegate *MVAD=[[[MapViewAppDelegate alloc]init]autorelease];
        MVAD.window.rootViewController=navC;
        //self.window.rootViewController=navC;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
