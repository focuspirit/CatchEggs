//
//  PlayLayer.m
//  cc2dTest
//
//  Created by Chang Shun-Kuei on 4/16/12.
//  Copyright (c) 2012 n/a. All rights reserved.
//
#import "GlobalVar.h"
#import "PauseLayer.h"
#import "PlayLayer.h"
#import "Egg.h"
#import "Chicken.h"
#import "SimpleAudioEngine.h"
#import "FlurryAnalytics.h"
#import "LocalyticsSession.h"
#import "AppDelegate.h"
#import "GCHelper.h"
#import "GANTracker.h"


@implementation PlayLayer

UIViewController *viewController;

#pragma mark
#pragma mark Life cycle
// on "init" you need to initialize your instance
- (id)init
{
	if( (self=[super init])) {
        
        winSize = [CCDirector sharedDirector].winSize;

        [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
        
        [gameManager loadScores];
        currentLevel=0;
        brokenEggCount = 0;
        displayBrokenEggs = 0;
        scoredPoint = 0;
        totalEggs = 0;
        nextUpgradeScore = (scoreUpgradeLV * sqrt(currentLevel+1)) + nextUpgradeScore;

        watch = [[Chronometer alloc] init];

        farmer = [[Farmer alloc] init];
                
        CGPoint startPostion = GLToUI(winSize.width/2, winSize.height-([farmer contentSize].height/2));

        
        [farmer setPosition:startPostion];
        
        [self addChild:farmer z:1];
        //[farmer actAnimation];
        
        NSInteger iTag=1;
        int i=0;
        for (Egg *egg in eggPool.pool)
        {
            egg.visible=NO;
            [egg setTag:iTag];

            [self addChild:egg z:2 tag:EGG_TAG_BEGIN+i];
            i++;
            iTag++;
        }
        //chickenPool = [[NSMutableArray alloc] init];
        
        for (int i=0; i<4; i++) {
            
            
            Chicken *chicken= [[[Chicken alloc] init] autorelease];
            

            int x = [chicken contentSize].width;
            int y = [chicken contentSize].height;
            
            int space=i*(x+CHICKEN_SPACE);
            
            x = CHICKEN_START_X+(x/2)+space;
            y = CHICKEN_START_Y+(y/2);

            CGPoint startPostion = GLToUI(x,y);
            
            [chicken setPosition:startPostion];
            [chicken setTag:CHICKEN_TAG_BEGIN+i];
            
            [self addChild:chicken z:1 tag:CHICKEN_TAG_BEGIN+i];

            
        }
        
        [self countdown];
        
        //


	}
	return self;
}

-(void)dealloc 
{  
    [watch release];
    [farmer release];
    [eggPool resetPool];

    [super dealloc];  
}  


#pragma mark
//#pragma mark Touch Event

static NSString *imgCTName[] = { @"countdown_3.png", @"countdown_2.png", @"countdown_1.png" };
CCSprite *countNum;

- (void)countdown
{
    
    countNum = [[[CCSprite alloc] init] autorelease];


    
    [countNum setPosition:ccp(winSize.width/2, winSize.height/2)];
    
    
    id zoomActions = [CCSequence actions:
                      [CCHide action],                          
                      [CCCallFuncND actionWithTarget:self selector:@selector(changeCTSprite:FrameIndex:) data:(void *)0], 
                      [CCScaleBy actionWithDuration:0.1 scale:0.5],
                      [CCShow action],
                      [CCCallFunc actionWithTarget:self selector:@selector(playCountdownSound)],
                      [CCScaleTo actionWithDuration:0.5 scale:3.0],
                      
                      [CCHide action],                          
                      [CCCallFuncND actionWithTarget:self selector:@selector(changeCTSprite:FrameIndex:) data:(void *)1], 
                      [CCScaleBy actionWithDuration:0.1 scale:0.5],
                      [CCShow action],
                      [CCCallFunc actionWithTarget:self selector:@selector(playCountdownSound)],
                      [CCScaleTo actionWithDuration:0.5 scale:3.0],
                      
                      [CCHide action],                          
                      [CCCallFuncND actionWithTarget:self selector:@selector(changeCTSprite:FrameIndex:) data:(void *)2], 
                      [CCScaleBy actionWithDuration:0.1 scale:0.5],
                      [CCShow action],
                      [CCCallFunc actionWithTarget:self selector:@selector(playCountdownSound)],
                      [CCScaleTo actionWithDuration:0.5 scale:3.0],
                      
                      [CCCallFunc actionWithTarget:self selector:@selector(finishCountDown)],
                      nil];
    
    //NSAssert(zoomActions!=nil, @"Countdown Action = nil");

    [countNum runAction:zoomActions];
    [self addChild:countNum z:3];
        

    
}

- (void)playCountdownSound
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"beep.caf"];

}

- (void)changeCTSprite:(id)sender FrameIndex:(int)idx
{
    CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:imgCTName[idx]];
    [countNum setDisplayFrame:frame];
    
}


- (void)finishCountDown
{
    

    [countNum removeFromParentAndCleanup:YES];
    
    [self addScoreLableAtPosition:ccp(10, 50)];

    [watch startWithPositionX:lableScored.position.x Y:30];
    [self addChild:watch];
    
    for (int i=0; i<4; i++) {
        [((Chicken *)[self getChildByTag:CHICKEN_TAG_BEGIN+i]) startAction];
    }
    CCLOG(@"watch.gameStart: %f ",watch.playStart);
    gameStart = watch.playStart;
    

    
    [farmer startAction];

    
    CCSprite *spriteNormal = [CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"pause.png"]];
    CCSprite *spriteSelected = [CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"pausePress.png"]];

    
    CCMenuItemSprite *pauseButton = [CCMenuItemSprite itemFromNormalSprite:spriteNormal selectedSprite:spriteSelected target:self selector:@selector(pauseTapped:)];    
    
    CCMenu *pauseMenu = [CCMenu menuWithItems:pauseButton, nil];

    [pauseMenu setPosition:GLToUI((winSize.width-(pauseButton.contentSize.width/2) - 20), (pauseButton.contentSize.height/2) + 10)];  

    [self addChild:pauseMenu z:0 tag:PAUSE_BUTTON_TAG];


    
    
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"chicken_sound.m4a" loop:YES];
    self.isTouchEnabled = YES;
    

}





-(void)update:(ccTime)delta
{
}

-(void)addScoreLableAtPosition:(CGPoint)sPosition
{
    
    CCLabelBMFont *lableLable = [CCLabelBMFont labelWithString:@"SCORE" fntFile:@"BebasNeue.fnt"];
    lableScored = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"%05d", scoredPoint] fntFile:@"BebasNeue.fnt"];

    
    int x = (lableLable.contentSize.width/2) + sPosition.x;
    int y = (lableLable.contentSize.height/2) + sPosition.y;
    
    [lableLable setPosition:GLToUI(x, y)];
    
    x = (lableScored.contentSize.width/2) + sPosition.x;

    y = sPosition.y + lableLable.contentSize.height + 5;
    
    [lableScored setPosition:GLToUI(x, y)];
    

    
    [self addChild: lableLable];
    [self addChild: lableScored];
    

    
    CCSprite *eggLog = [CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"eggLog.png"]];

    x = sPosition.x + (eggLog.contentSize.height/2);
    y += lableScored.contentSize.height;

    [eggLog setPosition:GLToUI(x, y)];
    [self addChild:eggLog];

    
    lableEggs = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"%03d", totalEggs] fntFile:@"BebasNeue.fnt"];

    x = sPosition.x + eggLog.contentSize.width + (lableEggs.contentSize.width/2);
    
    [lableEggs setPosition:GLToUI(x, y)];
    [self addChild: lableEggs];

    
    [self schedule:@selector(updateTenTimesPerSecond) interval:0.1f];
    [self schedule:@selector(miscChecker)];

}



- (void)updateTenTimesPerSecond
{
    [lableScored setString:[NSString stringWithFormat:@"%05d", scoredPoint]];
    [lableEggs setString:[NSString stringWithFormat:@"%03d", totalEggs]];
    
}

- (void)levelUP
{
    CCSprite *lvUP = [CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"LevelUP.png"]];
    [lvUP setVisible:NO];
    
    
    CGPoint position = farmer.boundingBox.origin;
    //center posintion is famer right uppper conner
    position.x += [farmer contentSize].width-10;
    position.y += [farmer contentSize].height;
    
    
    CGPoint endPosition = ccp(position.x, position.y+80);
    
    
    id action = [CCSequence actions:
                 [CCHide action],   
                 [CCPlace actionWithPosition:position],
                 [CCScaleBy actionWithDuration:0.1 scale:0.5],
                 [CCShow action],
                 [CCSpawn actions:
                    [CCScaleTo actionWithDuration:1.0 scale:2],
                    [CCEaseOut actionWithAction: [CCMoveTo actionWithDuration:1.0 position: endPosition] rate:0.5],
                    nil], 
                 [CCHide action], 
                 nil];
    
    
    
    [lvUP runAction:action];
    [self addChild:lvUP];
    
}


- (void)calcLevelUp
{

    //if(forwardLv<currentLevel) 
    if(scoredPoint>nextUpgradeScore) 
    {
        
        //CCLOG(@"LevelUP: %f",10-currentLevel*basiFormula);
        //下次升級必須分數 = (升級分數基數*下個等級平方根)+目前升級分數
        //用while的原因是怕如果得到高分的物件可能就會一次過兩個等級
        while (scoredPoint>nextUpgradeScore) 
        {
            nextUpgradeScore = (scoreUpgradeLV * sqrt(currentLevel+1)) + nextUpgradeScore;
            currentLevel++;
        }
        

        [self levelUP];
    }   
    
}


- (void)miscChecker
{
    [self calcLevelUp];
    
    if (brokenEggCount>displayBrokenEggs) 
    {
        
        CCSprite *brokenEgg = [CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"broken_egg.png"]];

        int x = winSize.width - (brokenEgg.contentSize.width/2) - 20;
        int y = (brokenEgg.contentSize.height/2)+(brokenEgg.contentSize.height*displayBrokenEggs) +(10*displayBrokenEggs)+ 60;
        [brokenEgg setPosition:GLToUI(x, y)];
        
        [self addChild:brokenEgg];
        displayBrokenEggs++;

    }
    
    
    
    if(brokenEggCount>=5)
    {
        [self unschedule:_cmd];
        // CCLOG(@"GameOver");
        self.isTouchEnabled = NO;
        isPause=YES;
        if(overView==nil)
        {
            overView= [[OverView alloc] initWithFrame:CGRectMake(0, 0, 480, 320)];
            [overView regesterRestartButtonWithTarget:self action:@selector(backMain:)];
            [overView setTimeText:[NSString stringWithFormat:@"TIMES:%@",[watch pastTimeToStirng] ]];
            [overView setScoreText:[NSString stringWithFormat:@"CREDIT SCORES:%05d", scoredPoint]];
            [overView setEggsText:[NSString stringWithFormat:@"CATCH EGGS:%03d", totalEggs]];

        }
        [[CCDirector sharedDirector] pause]; 
        [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];

        [gameManager saveScores:scoredPoint miutes:[watch playMinutes] seconds:[watch playSeconds]];
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"gameover.m4a" loop:NO];

        [[[CCDirector sharedDirector] openGLView] addSubview:overView];  

    }
    
}


- (void)pauseTapped:(id)sender
{
    
    [[SimpleAudioEngine sharedEngine] playEffect:@"click.caf"];

    if(isPause==NO)
    {
        [[SimpleAudioEngine sharedEngine] pauseBackgroundMusic];;

        isPause=YES;
        self.isTouchEnabled = NO;
        ((CCMenu *)[self getChildByTag:PAUSE_BUTTON_TAG]).isTouchEnabled = NO;

        
        [[CCDirector sharedDirector] pause];  
        if(pauseView==nil)
        {
            pauseView= [[PauseView alloc] initWithFrame:CGRectMake(0, 0, 480, 320)];
            [pauseView regesterPlayButtonWithTarget:self action:@selector(pauseTapped:)];
            [pauseView regesterRestartButtonWithTarget:self action:@selector(backMain:)];
        }
        //pauseStart = CFAbsoluteTimeGetCurrent();

        [watch pauseClock];
        
        [[[CCDirector sharedDirector] openGLView] addSubview:pauseView];  
        
        
        
    }
    else {
        
        if(pauseView!=nil)
        {


            [pauseView removeFromSuperview];
            pauseView = nil;
            [[CCDirector sharedDirector] resume];

            
            [watch resumeClock];
            
            pauseStart=0;
            
        }
        self.isTouchEnabled = YES;
        ((CCMenu *)[self getChildByTag:PAUSE_BUTTON_TAG]).isTouchEnabled = YES;

        isPause=NO;
        [[SimpleAudioEngine sharedEngine] resumeBackgroundMusic];;

    }   
    
}

- (void)backMain:(id)sender
{
    int finishReason = 0;
    if(pauseView!=nil) 
    {
        CCLOG(@"remove pause view");
        [pauseView removeFromSuperview];
        [pauseView release];
        pauseView = nil;
    }
    if(overView!=nil) 
    {
        CCLOG(@"remove overView view");
        [overView removeFromSuperview];
        [overView release];
        overView = nil;
        finishReason = 1;
    }
    /////////

    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                identifyUser, @"USER",
                                [NSString stringWithFormat:@"%06d", scoredPoint], @"SCORES",
                                [watch pastTimeToStirng], @"TIMES",
                                [NSString stringWithFormat:@"%03d", totalEggs], @"EGGS",
                                finishReason > 0 ? @"GameOver":@"Interrupt", @"REASON",
                                [GCHelper sharedGCHelper].playerID, @"CG_ID",
                                [GCHelper sharedGCHelper].playerAlias, @"CG_ALIAS",
                                [[UIDevice currentDevice] name], @"NAME",
                                nil];
    [[LocalyticsSession sharedLocalyticsSession] tagEvent:@"PLAYLOG" attributes:dictionary];
    
    [FlurryAnalytics logEvent:@"PLAYLOG" withParameters:dictionary];
    
    NSError *error;
    

    

    [[GANTracker sharedTracker] trackEvent:@"PLAYLOG"
                                    action:@"SCORES"
                                     label:identifyUser
                                     value:scoredPoint
                                 withError:&error];
    
    [[GANTracker sharedTracker] trackEvent:@"PLAYLOG"
                                    action:@"EGGS"
                                     label:identifyUser
                                     value:totalEggs
                                 withError:&error];

    [[GANTracker sharedTracker] trackEvent:@"PLAYLOG"
                                    action:@"TIMES"
                                     label:identifyUser
                                     value:((watch.playMinutes*60)+watch.playSeconds)
                                 withError:&error];
    
    [[GANTracker sharedTracker] trackEvent:@"PLAYLOG"
                                    action:@"REASON"
                                     label:identifyUser
                                     value:finishReason
                                 withError:&error];
    
    [[GANTracker sharedTracker] trackEvent:@"PLAYLOG"
                                    action:@"NAME"
                                     label: [[UIDevice currentDevice] name]
                                     value:0
                                 withError:&error];
    /////////
    isPause=NO;

    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];

    [[CCDirector sharedDirector] resume];   //恢復被暫停的timer,action等...如果沒恢復會造成其他scene不能動作
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"theme.m4a" loop:YES];

    [gameManager runSceneWithID:kMainMenuScene];
    //[[CCDirector sharedDirector] popScene];

}



#pragma mark
#pragma mark Touch Event

/* Process touch events */
- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event 
{
    UITouch *touch = [touches anyObject];
    startTouchPosition = [touch locationInView: [touch view]];

    
    [farmer touch:YES];    
}

-(void) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event 
{
    UITouch *touch = [touches anyObject];
    currentTouchPosition = [touch locationInView: [touch view]];
    CGPoint point = [[CCDirector sharedDirector] convertToGL: currentTouchPosition];
    
    
    
    if (fabsf(startTouchPosition.x -currentTouchPosition.x) >= HORIZ_SWIPE_DRAG_MIN  )   
    {
        // Horizontal Swipe
        if (startTouchPosition.x <currentTouchPosition.x) 
        {
            direction = kCATransitionFromLeft;
  
        }
        else
        {
            direction = kCATransitionFromRight;
        }
        //currentTouchPosition是OpenGL座標系所以不用轉成CoreGraphic
        [farmer setPosition:ccp(currentTouchPosition.x, farmer.position.y)];
        [farmer updatCatchBox];
        startTouchPosition = currentTouchPosition;
        
        
        
        
    }
}

-(void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event 
{
    UITouch *touch = [touches anyObject];
    endedTouchPosition = [touch locationInView: [touch view]];
    CGPoint point = [[CCDirector sharedDirector] convertToGL: endedTouchPosition];
    
    //CCLOG(@"ccTouchesEnded:%@",NSStringFromCGPoint(point));
    [farmer touch:NO];    
}


#pragma mark
#pragma mark Utility


void	Dec2Char(int nu,char *ch)
{
    int	i,off,j;
    
    int b=nu;
    int c=0;
    
    while(b)   { b/=10;   c++;} 
    
    
    if(c==0)    return;
    
    char temp[c+1];
    int valRemainder = 10;
    int divValue = 1;
    b = nu;
    for (int i=0, cd = c-1 ; i<c; i++, cd--) 
    {
        int remainder = b % valRemainder;
        int val = remainder / divValue;
        
        valRemainder *= 10;
        divValue *=10;
        
        temp[cd] = '0'+val;
        
    }
    temp[c]='\0';
    
    j=strlen(ch);
    off=j-c;
    
    i=0;
    for(;i<off;i++)	*(ch+i)='0';
    
    for(int ct=0;i<j;i++,ct++)	*(ch+i)=temp[ct];
    
    
}

#pragma mark -
#pragma mark ========== AdWhirlDelegate 函式 ==========

- (void) onEnter { 
    
 
    
    viewController = [(AppDelegate*)[[UIApplication sharedApplication] delegate] viewController];
    //viewController = [[UIViewController alloc] init];    //設置viewController，用於顯示廣告，如果這個設置錯誤，則廣告不能正常顯示，也不能打開窗口顯示廣告。 
    viewController.view = [[CCDirector sharedDirector] openGLView]; 
    awView = [AdWhirlView requestAdWhirlViewWithDelegate:self]; 
    awView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
    [awView updateAdWhirlConfig];
    [awView setFrame:CGRectMake(80, 0, 320, 48)];

    //CGSize adSize = [awView actualAdSize];
    //Trying to keep everything inside the Ad bounds    
    awView.clipsToBounds = YES;
    awView.hidden=YES;
    //Adding the adView (used for our Ads) to our viewController    
    [viewController.view addSubview:awView];
    //Bring our view to front    
    [viewController.view bringSubviewToFront:awView];
    

     [super onEnter]; 
} 

- (NSString *)adWhirlApplicationKey {
	//在AdWhirlDelegate的函式中輸入licenseKey
    
	return @"licenseKey";
    
}

- (UIViewController *)viewControllerForPresentingModalView {
	return viewController;
}

- (BOOL)adWhirlTestMode{
	/*
	 * 非測試時，參數設為NO
	 * 測試時，參數設為YES 
	 */
	return NO;
}

- (void)adWhirlDidReceiveAd:(AdWhirlView *)adWhirlView { 
    
    
    if (YES == awView.hidden) { 
        awView.hidden=NO; 
    } 
    [self adjustAdSize]; 
} 
- (void)adjustAdSize { 

    
    [UIView beginAnimations:@"AdResize" context:nil];
    [UIView setAnimationDuration:0.7];
    
    //縮小廣告尺寸
    viewController = [(AppDelegate*)[[UIApplication sharedApplication] delegate] viewController];
    
    CGSize adSize = [awView actualAdSize];
    CGRect newFrame = awView.frame;
    newFrame.size.height = adSize.height*0.75; // fit the ad
    newFrame.size.width = adSize.width*0.75;
    newFrame.origin.x = (viewController.view.bounds.size.width - newFrame.size.width)/2; // center
    awView.frame = newFrame;
    
    awView.transform = CGAffineTransformMakeScale(0.75, 0.75);
    
    // ... adjust surrounding views here ...
    [UIView commitAnimations];
    
} 

-(void)onExit {
    //There's something weird about AdWhirl because setting the adView delegate
    //to "nil" doesn't stops the Ad requests and also it doesn't remove the adView
    //from superView; do the following to remove AdWhirl from your scene.
    //
    //If adView exists, remove everything
    if (awView) {

        //Replace adView's view with "nil"
        [awView replaceBannerViewWith:nil];
        //Tell AdWhirl to stop requesting Ads
        [awView ignoreNewAdRequests];
        
        
        //Set adView delegate to "nil"
        [awView setDelegate:nil];

        //Remove adView from superView
        [awView removeFromSuperview];     
        /*
        //Release adView
        [awView release];
        //set adView to "nil"
        awView = nil;
         */
         
    }
    [super onExit];
}
@end
