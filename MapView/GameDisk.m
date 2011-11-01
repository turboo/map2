#import "GameDisk.h"
@implementation GameDisk
NSUInteger RandomCount;
NSUInteger TurnON=0;
NSUInteger ArrayCount;
+ (id)scene
{
	CCScene *scene = [CCScene node];
	CCLayer *layer = [GameDisk node];
	[scene addChild:layer];
	
	return scene;
}

- (id)init
{
	if((self = [super init])) {
        NameArray=[[NSMutableArray alloc]initWithObjects:@"Sleep",@"in",@"Taipei",nil]; 
        [NameArray addObject:@"This"];
        [NameArray addObject:@"is"];
        [NameArray addObject:@"a"];
        [NameArray addObject:@"big"];
        [NameArray addObject:@"shit"];
        ArrayCount=NameArray.count;
        
		CCLOG(@"MainScene init");
		CGSize size = [[CCDirector sharedDirector]winSize];
        
        Door = [CCSprite spriteWithFile:@"door/door1.png"]; 
        [Door setPosition:ccp(size.width/2,220)];
        [self addChild:Door z:10];
        
        AnswerForm = [[CCLabelTTF labelWithString:@"Label" 
                               dimensions:CGSizeMake(320, 50) alignment:UITextAlignmentCenter 
                                  fontName:@"Arial" fontSize:32.0] retain];
        AnswerForm.position = ccp(size.width/2,390);
        [self addChild:AnswerForm z:9];       
        AnswerForm.visible=NO;
        
        AnswerLabel=[CCSprite spriteWithFile:@"Label.png"];
        AnswerLabel.position = ccp(size.width/2,400);
        AnswerLabel.scale=0.5f;
        [self addChild:AnswerLabel z:8];
        AnswerLabel.visible=NO;
        
        PlayButton = [CCMenuItemImage 
                      itemFromNormalImage:@"ButtonOn.png" selectedImage:@"ButtonOff.png" 
                      target:self selector:@selector(PlayFunction:)];
        PlayButton.position = ccp(size.width/2,5);
        PlayButton.scale=0.4f;
        PlayButton.visible=YES;
        
        GoButton = [CCMenuItemImage 
                      itemFromNormalImage:@"GoButtonOn.png" selectedImage:@"GoButtonOff.png" 
                      target:self selector:@selector(PlayFunction:)];
        GoButton.position = ccp(size.width/2,280);
        GoButton.scale=0.4f;
        GoButton.visible=NO;
        
        ButtonMenu = [CCMenu menuWithItems:PlayButton,GoButton, nil];
        ButtonMenu.position = CGPointZero;
        [self addChild:ButtonMenu z:7];
        ButtonMenu.visible=NO;
        Sign =[CCSprite spriteWithFile:@"Sign.png"];
        Sign.position = ccp(size.width/2,50);
        Sign.scale=0.2f;
        [self addChild:Sign z:6];
        Sign.visible=NO;
        
        TryAgainForm = [[CCLabelTTF labelWithString:@"還想玩？再按一次！！" 
                                         dimensions:CGSizeMake(320, 50) alignment:UITextAlignmentCenter 
                                           fontName:@"Arial" fontSize:20.0] retain];
        TryAgainForm.position = ccp(size.width/2,180);
        [self addChild:TryAgainForm z:5];       
        TryAgainForm.visible=NO;
        
        Bridge =[CCSprite spriteWithFile:@"拱橋.png"];
        Bridge.position = ccp(size.width/2,70);
        Bridge.scale=0.6f;
        [self addChild:Bridge z:4];
        Bridge.visible=NO;
        
        PopDisk = [CCSprite spriteWithFile:@"Disk.png"];
        PopDisk.scale=0.3f;
        PopDisk.position = ccp(size.width/2,0);
        [self addChild:PopDisk z:3];
        PopDisk.visible=NO;  
        
        //        Backimage = [CCSprite spriteWithFile:@"pub.jpg"];
        //        Backimage.scale=2.0f;
        //        Backimage.position = ccp(250,380);
        //        [self addChild:Backimage z:0];
        
        DiskAction=[CCSpawn actions: 
                   //[CCMoveTo actionWithDuration:1 position: ccp(size.width/2,120)],
                    [CCScaleTo actionWithDuration:1 scale:0.9f], 
                    nil];
        DiskAllAction=[CCSpawn actions:
                   DiskAction,
                   [CCCallFunc actionWithTarget:self selector:@selector(OpenTheDoor)],
                    nil];
        AllAction=[CCSequence actions:
                   DiskAllAction,
                   [CCCallFunc actionWithTarget:self selector:@selector(ShowAndHiden)],
                   nil];
        [PopDisk runAction:AllAction];
        
        diskRotation = 0;
        self.isTouchEnabled = YES;  
        [[UIAccelerometer sharedAccelerometer] setUpdateInterval:1/60];
        [self scheduleUpdate];
	}
    return self;
}
- (void)GoToDetail{

}
- (void)ShowAndHiden{
    Door.visible=NO;
    PlayButton.visible=YES;
    PopDisk.visible=YES;
    GoButton.visible=NO;
    ButtonMenu.visible=YES;
    Bridge.visible=YES;
    Sign.visible=YES;
}

- (void)OpenTheDoor{
    DoorPic = [CCAnimation animation]; 
    [DoorPic addFrameWithFilename:@"door/door2.png"]; 
    [DoorPic addFrameWithFilename:@"door/door3.png"]; 
    [DoorPic addFrameWithFilename:@"door/door4.png"];
    [DoorPic addFrameWithFilename:@"door/door5.png"];
    [DoorPic addFrameWithFilename:@"door/door6.png"];
    [DoorPic addFrameWithFilename:@"door/door7.png"];
    [DoorPic addFrameWithFilename:@"door/door8.png"];
    [DoorPic addFrameWithFilename:@"door/door9.png"];
    [DoorPic addFrameWithFilename:@"door/door10.png"];
    [DoorPic addFrameWithFilename:@"door/door11.png"];
    [DoorPic addFrameWithFilename:@"door/door12.png"];
    [DoorPic addFrameWithFilename:@"door/door13.png"];
    [DoorPic addFrameWithFilename:@"door/door14.png"];
    [DoorPic addFrameWithFilename:@"door/door15.png"];
    [DoorPic addFrameWithFilename:@"door/door16.png"];
    [DoorPic addFrameWithFilename:@"door/door17.png"];
    [DoorPic addFrameWithFilename:@"door/door18.png"];
    [DoorPic addFrameWithFilename:@"door/door19.png"];
    [DoorPic addFrameWithFilename:@"door/door20.png"];
    id DoorAction = [CCAnimate actionWithDuration:1.2f animation:DoorPic restoreOriginalFrame:NO ];
    DoorAllaction=[CCSpawn actions:DoorAction,
               [CCScaleTo actionWithDuration:1 scale:1.5f],
               nil];
    [Door runAction:DoorAllaction];
    
}
- (void)PlayFunction:(id)sender{
    CGPoint firstLocation;
    firstLocation.x=100.0f;
    firstLocation.y=120.0f;
	CGPoint location;
    location.x=200.0f;
    location.y=120.0f;
    CGPoint firstTouchingPoint = [[CCDirector sharedDirector] convertToGL:firstLocation];//第一點
	CGPoint touchingPoint = [[CCDirector sharedDirector] convertToGL:location];//正在碰的點
	CGPoint firstVector = ccpSub(firstTouchingPoint, PopDisk.position);//第一次計算
	CGFloat firstRotateAngle = -ccpToAngle(firstVector);//第一次旋轉角度
	CGFloat previousTouch = CC_RADIANS_TO_DEGREES(firstRotateAngle);//上一次碰點
	CGPoint vector = ccpSub(touchingPoint, PopDisk.position);//計算
	CGFloat rotateAngle = -ccpToAngle(vector);//旋轉角度
	CGFloat currentTouch = CC_RADIANS_TO_DEGREES(rotateAngle);//現在的點
	angleBeforeTouchesEnd = currentTouch - previousTouch;//最後角度
	diskRotation += currentTouch - previousTouch;//轉盤旋轉
    AnswerLabel.visible=YES;
    AnswerForm.visible=YES;
    GoButton.visible=NO;
    TryAgainForm.visible=NO;
    TurnON=0;
}

- (void)update:(ccTime)delta
{
	PopDisk.rotation = diskRotation;
	if (fabs(angleBeforeTouchesEnd)>1)
	{
		angleBeforeTouchesEnd=angleBeforeTouchesEnd*0.99;
		diskRotation+=angleBeforeTouchesEnd;
        RandomCount=random()%ArrayCount;
        [AnswerForm setString:[NameArray objectAtIndex:RandomCount]];
        TurnON=1;
        
    }
	else {
        if (TurnON==1) {
            TryAgainForm.visible=YES;
            GoButton.visible=YES;
        }
        angleBeforeTouchesEnd = 0;
    }
    
   
	
}



- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	angleBeforeTouchesEnd = 0;
}

- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [touches anyObject];
	
	CGPoint firstLocation = [touch previousLocationInView:[touch view]];
	CGPoint location = [touch locationInView:[touch view]];
	
    
	CGPoint touchingPoint = [[CCDirector sharedDirector] convertToGL:location];//最後點
	CGPoint firstTouchingPoint = [[CCDirector sharedDirector] convertToGL:firstLocation];//第一點
	
	CGPoint firstVector = ccpSub(firstTouchingPoint, PopDisk.position);//兩點之間的距離
	CGFloat firstRotateAngle = -ccpToAngle(firstVector);//弧度
	CGFloat previousTouch = CC_RADIANS_TO_DEGREES(firstRotateAngle);//角度
	
	CGPoint vector = ccpSub(touchingPoint, PopDisk.position);//
	CGFloat rotateAngle = -ccpToAngle(vector);//
	CGFloat currentTouch = CC_RADIANS_TO_DEGREES(rotateAngle);//
	angleBeforeTouchesEnd = currentTouch - previousTouch;
    
	diskRotation += currentTouch - previousTouch;//
	
}

- (void)dealloc
{
    [NameArray release];
	[super dealloc];
}
@end
