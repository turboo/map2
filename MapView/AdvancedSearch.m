//
//  AdvancedSearchViewControllerViewController.m
//  AdvancedSearchViewController
//
//  Created by MBP on 11/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AdvancedSearch.h"

@implementation AdvancedSearch

//點擊文字框以外的地方隱藏鍵盤
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [WordSearhText resignFirstResponder];
    [super touchesBegan:touches withEvent:event];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
-(IBAction)changeSegmentItem:(UISegmentedControl *)sender
{
	switch (sender.selectedSegmentIndex) {
        case 0://住宿價格
            nightSC.hidden=NO;
            break;
        case 1://休息價格
            nightSC.hidden=YES;
            break;
    }
	
}
-(IBAction)ADsearch
{
    NSString *SearchText=WordSearhText.text;
    switch (WordSC.selectedSegmentIndex){
        case 0:
            NSLog(@"旅館名稱:%@",SearchText);
            break;
        case 1:
            NSLog(@"旅館地址:%@",SearchText);
            break;
    }
    NSLog(@"價格區間:");
    if(nightSC.selectedSegmentIndex != 0 || restSC.selectedSegmentIndex != 0){
        switch (nightSC.selectedSegmentIndex) {
            case 1:
                NSLog(@"~1499");
                break;
            case 2:
                NSLog(@"1500~2999");
                break;
            case 3:
                NSLog(@"3000~");
                break;
        }
        switch (restSC.selectedSegmentIndex) {
            case 1:
                NSLog(@"~999");
                break;
            case 2:
                NSLog(@"1000~1999");
                break;
            case 3:
                NSLog(@"2000~");
                break;
        }
    }
    NSLog(@"查詢開始");


}
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    
    
    [super viewDidLoad];
    self.view.backgroundColor = nil;
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
