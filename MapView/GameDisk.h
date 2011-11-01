#import <Foundation/Foundation.h>
//#import "cocos2d.h"
@interface GameDisk : CCLayer 
{
    CCMenuItem *GoButton;
    CCMenuItem *PlayButton;
    CCMenu *ButtonMenu;
    
    
    CCSprite *Sign;
    CCSprite *AnswerLabel;
    CCSprite *Bridge;
    CCSprite *Door;
    CCSprite *PopDisk;
    CCSprite *Backimage;
	CCSprite *AnswerSign;
    CCLabelTTF *AnswerForm;
    CCLabelTTF *TryAgainForm;
    CCAnimation *DoorPic;
    
    CCSpawn *DoorAllaction;
    CCSpawn *DiskAction;
    CCSpawn *DiskAllAction;
    CCSequence *AllAction;
    
    NSInteger *number;
    NSString *str;
    CGFloat diskRotation;
	CGFloat angleBeforeTouchesEnd;//轉盤每次減速角度
    NSMutableArray *NameArray;
    
}
+(CCScene*)scene;
- (void)PlayFunction:(id)sender;
- (void)GoToDetail;
- (void)OpenTheDoor;
- (void)ShowAndHiden;
@end
