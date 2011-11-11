//
//  AdvancedSearch.m
//  AdvancedSearch
//
//  Created by MBP on 11/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AdvancedSearch.h"

@implementation AdvancedSearch

@synthesize wordSearhText;

//點擊文字框以外的地方隱藏鍵盤
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
  NSLog(@"ToDo:touchesBegan");
  [wordSearhText resignFirstResponder];
  [super touchesBegan:touches withEvent:event];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}



#pragma mark - View lifecycle
-(IBAction)changePriceItemPrice:(UISegmentedControl *)sender
{
  NSLog(@"ToDo:changePriceItemPrice:%d",sender.selectedSegmentIndex);
	switch (sender.selectedSegmentIndex) {
        case 0://住宿價格
            NSLog(@"住宿價格");
            staySC.hidden=NO;
            restSC.hidden=YES;
            break;
        case 1://休息價格
            NSLog(@"休息價格");
            restSC.hidden=NO;
            staySC.hidden=YES;
            break;
        default:
            NSLog(@"Other:%d",sender.selectedSegmentIndex);
            break;
    }
	
}
-(IBAction)changeKeywordItem:(UISegmentedControl *)sender
{
  NSLog(@"ToDo:changeKeywordItem:%d",sender.selectedSegmentIndex);
	switch (sender.selectedSegmentIndex) {
    case 0:// 旅館名稱
      NSLog(@"旅館名稱:%@",wordSearhText.text);
      break;
    case 1://旅館地址
      NSLog(@"旅館地址:%@",wordSearhText.text);
      break;
    default:
      NSLog(@"Other:%d",sender.selectedSegmentIndex);
      break;
  }
	
}
-(IBAction)doAdvancedSearch
{
  NSLog(@"ToDo:doAdvancedSearch");
    NSString *searchText=wordSearhText.text;
    NSString *predicateString = @"(areaCode > 0)";
    if ([searchText length]>0)
    {
      switch (wordSC.selectedSegmentIndex){
          case 0:
              NSLog(@"旅館名稱:%@",searchText);
              predicateString = [predicateString stringByAppendingFormat:@" AND (displayName contains '%@')",searchText];
              break;
          case 1:
              NSLog(@"旅館地址:%@",searchText);
              predicateString = [predicateString stringByAppendingFormat:@" AND (address contains '%@')",searchText];
              break;
      }
    }
    NSLog(@"價格區間:");
    if (restSC.hidden == YES)
    {
        switch (staySC.selectedSegmentIndex) {
          case 0:
                predicateString = [predicateString stringByAppendingFormat:@" AND (costStay > 0)"];
                break;
          case 1:
                predicateString = [predicateString stringByAppendingFormat:@" AND (costStay > 1500)"];
                break;
            case 2:
                predicateString = [predicateString stringByAppendingFormat:@" AND (costStay between 1500 and 2999)"];
                break;
            case 3:
                predicateString = [predicateString stringByAppendingFormat:@" AND (costStay >= 3000)"];
                break;
        }
    }
    else
    {
        switch (restSC.selectedSegmentIndex) {
            case 0:
                NSLog(@"rest: ALL");
                predicateString = [predicateString stringByAppendingFormat:@" AND (costRest > 0)"];
                break;
            case 1:
                NSLog(@"rest: ~999");
                predicateString = [predicateString stringByAppendingFormat:@" AND (costRest > 1000)"];
                break;
            case 2:
                predicateString = [predicateString stringByAppendingFormat:@" AND (costRest between 1000 and 1999)"];
                break;
            case 3:
                predicateString = [predicateString stringByAppendingFormat:@" AND (costRest >= 2000)"];
                break;
        }
    }
    NSLog(@"查詢開始:%@",predicateString);
//    SearchHotelQuery *hotelQuery = [[SearchHotelQuery alloc]init];
//    [hotelQuery inputKeyWordAndListData:predicateString];
//    [hotelQuery release];
  TotalTableViewController *tableView = [[TotalTableViewController alloc]initWithPredicateString:predicateString EntryTag:[NSNumber numberWithInt:999] ];
  [self.navigationController pushViewController:tableView animated:YES];
  
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
