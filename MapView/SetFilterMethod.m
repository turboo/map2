//
//  SetFilterMethod.m
//  MapView
//
//  Created by MBP on 10/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SetFilterMethod.h"

@implementation SetFilterMethod

- (void) viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    
    //self.view.clipsToBounds = NO;
    [self.navigationController setToolbarHidden:NO animated:animated];    
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
