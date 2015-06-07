//
//  Farmer.m
//  cc2dTest
//
//  Created by Chang Shun-Kuei on 4/13/12.
//  Copyright (c) 2012 n/a. All rights reserved.
//
#import "Farmer.h"
#import "GameManager.h"

@implementation Farmer

@synthesize catchBox, hitBox;

-(id) init {
    
    if(self=[super init])
    {
        holdTime = 0; 
        lastMoved = 0; 
        touchedState = TS_NONE; 
        isTouched = NO; 
        lastTouchedPoint = ccp(0,0);

        frameMarch = [[NSMutableArray alloc] init];

        
        CGRect rect=[[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"farmer_U0.png"] rect];
        [self setContentSize:rect.size];
        
        CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"farmer_U0.png"];
        [self setDisplayFrame:frame];


    }
    return self;
}

- (void)dealloc
{
    [frameMarch release];
    [self cleanup];
    [super dealloc];
}


- (void)startAction
{
    CCLOG(@"farmer startAction!!");

    [frameMarch addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"farmer_U0.png"]];
    [frameMarch addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"farmer_U1.png"]];
    [frameMarch addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"farmer_U2.png"]];
    [frameMarch addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"farmer_U3.png"]];
    animateMarch = [CCAnimation animationWithFrames:frameMarch delay:0.2f]; 
    marchAction = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:animateMarch
                                                              restoreOriginalFrame:NO]];
    
    
    
    
    [self actionMarch];
}




- (void)actionMarch
{
    [self runAction:marchAction];
    
}
- (void)pauseActions 
{

    [[[GameManager sharedGameManager] actionMgr] pauseTarget:self];
    
}

- (void)resumeActions 
{
    [[[GameManager sharedGameManager] actionMgr] resumeTarget:self];

    // CCLOG(@"numberOfRunningActionsInTarget: %d",[[[GameManager sharedGameManager] actionMgr] numberOfRunningActionsInTarget:self]);


}
- (void)actionHit
{

    [[[GameManager sharedGameManager] actionMgr] removeAllActionsFromTarget:self];

    [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"farmer_hit.png"]];
    
    id hitActions = [CCSequence actions:
                      [CCEaseOut actionWithAction:[CCScaleTo actionWithDuration:0.02 scale:1.5] rate:0.7],
                       [CCDelayTime actionWithDuration:0.2],
                       [CCScaleTo actionWithDuration:0.03 scale:1.0], 
                     [CCCallFunc actionWithTarget:self selector:@selector(startAction)],
                     nil];   
    [self runAction: hitActions];

    
    

}

- (void)updatCatchBox
{

    catchBox = CGRectMake(self.boundingBox.origin.x+FARMER_DETECT_OFFSET_LEFT,
                            self.boundingBox.origin.y+FARMER_DETECT_OFFSET_TOP, 
                            self.boundingBox.size.width-(FARMER_DETECT_OFFSET_LEFT+FARMER_DETECT_OFFSET_RIGHT), 
                            self.boundingBox.size.height-(FARMER_DETECT_OFFSET_TOP+FARMER_DETECT_OFFSET_BOTTOM));
    
    hitBox = CGRectMake(self.boundingBox.origin.x+FARMER_HITDETECT_OFFSET_LEFT,
                          self.boundingBox.origin.y+FARMER_HITDETECT_OFFSET_TOP, 
                          self.boundingBox.size.width-(FARMER_HITDETECT_OFFSET_LEFT+FARMER_HITDETECT_OFFSET_RIGHT), 
                          self.boundingBox.size.height-(FARMER_HITDETECT_OFFSET_TOP+FARMER_HITDETECT_OFFSET_BOTTOM));
    
}

- (void)changeToHitFrame
{
    [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"farmer_hit.png"]];
}

- (void)touch:(BOOL)flag
{
    // CCLOG(@"touch status change");
    
    if(flag)    self.scale=1.3f;
    else        self.scale=1.0f;

}


@end
