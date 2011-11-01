//
//  MapViewAppDelegate.h
//  MapView
//
//  Created by wan zhen lee on 10/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationSearchViewController.h"
#import "MADataStore.h"

@interface MapViewAppDelegate : NSObject <UIApplicationDelegate>
{
	UIWindow			*window_;
}
@property (nonatomic, retain) IBOutlet UIWindow *window_;


@end
