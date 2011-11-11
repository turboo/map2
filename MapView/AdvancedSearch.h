//
//  AdvancedSearch.h
//  AdvancedSearch
//
//  Created by MBP on 11/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchHotelQuery.h"
#import "TotalTableViewController.h"

@interface AdvancedSearch : UIViewController<UITextFieldDelegate>
{
    IBOutlet UISegmentedControl *wordSC;
    //IBOutlet UISegmentedControl *changeSC;
    IBOutlet UISegmentedControl *staySC;
    IBOutlet UISegmentedControl *restSC;
    IBOutlet UITextField *wordSearhText;
    IBOutlet UIButton *sendBtn;
    //UISegmentedControl *sendControl;
}
-(IBAction)changePriceItemPrice:(UISegmentedControl *)sender;
-(IBAction)changeKeywordItem:(UISegmentedControl *)sender;
-(IBAction)doAdvancedSearch;

@property (nonatomic , retain)UITextField *wordSearhText;

@end
