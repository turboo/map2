//
//  AdvancedSearchViewControllerViewController.h
//  AdvancedSearchViewController
//
//  Created by MBP on 11/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdvancedSearch : UIViewController<UITextFieldDelegate>
{
    IBOutlet UISegmentedControl *WordSC;
    IBOutlet UISegmentedControl *ChangeSC;
    IBOutlet UISegmentedControl *nightSC;
    IBOutlet UISegmentedControl *restSC;
    IBOutlet UITextField *WordSearhText;
    IBOutlet UIButton *SBtn;
    UISegmentedControl *SControl;
}
-(IBAction)changeSegmentItem:(UISegmentedControl *)sender;
-(IBAction)ADsearch;
@end
