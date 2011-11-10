//
//  MapViewAppDelegate.m
//  MapView
//
//  Created by wan zhen lee on 10/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


#import "MapViewAppDelegate.h"


@implementation MapViewAppDelegate
@synthesize window=_window;
//@synthesize viewController=viewController_;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{   
    //LocationSearchViewController *lsvc=[[[LocationSearchViewController alloc]init]autorelease];
    //UINavigationController *nac=[[[UINavigationController alloc]initWithRootViewController:lsvc]autorelease];
    
    //self.window.rootViewController=nac;
        //
    //   開始動畫淡出
    //
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Default"]];
    [self.window addSubview:imgView];
    [imgView release];
    [UIView animateWithDuration:2 animations:^(void){imgView.alpha = 0.0f;}];
    //[imgView removeFromSuperview];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:YES];    //

        
    self.window.backgroundColor = [UIColor blackColor];
    
    [self.window makeKeyAndVisible];
    return YES;
}

-(IBAction)ChangeNavigatinItemTitle:(id)sender
{
     
}


- (void)dealloc
{
	//[[CCDirector sharedDirector] end];
  [_window release];
	//[viewController_ release];
	[super dealloc];
}

- (void) removeStartupFlicker
{
	//
	// THIS CODE REMOVES THE STARTUP FLICKER
	//
	// Uncomment the following code if your Application only supports landscape mode
	//
  
  //	CC_ENABLE_DEFAULT_GL_STATES();
  //	CCDirector *director = [CCDirector sharedDirector];
  //	CGSize size = [director winSize];
  //	CCSprite *sprite = [CCSprite spriteWithFile:@"Default.png"];
  //	sprite.position = ccp(size.width/2, size.height/2);
  //	sprite.rotation = -90;
  //	[sprite visit];
  //	[[director openGLView] swapBuffers];
  //	CC_ENABLE_DEFAULT_GL_STATES();
}

@end
