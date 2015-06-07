//
//  Chicken.m
//  cc2dTest
//
//  Created by Chang Shun-Kuei on 4/21/12.
//  Copyright (c) 2012 n/a. All rights reserved.
//

#import "Chicken.h"
#import "PlayLayer.h"
#import "Egg.h"
extern PlayLayer  *playLayer;

@implementation Chicken


-(id) init {

    if(self=[super init])
    {
        actionFrames = [[NSMutableArray alloc] init];
        
        int currentActionNum = arc4random() % (2);
        
        
        CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"chicken%d.png",currentActionNum+1]];
        [self setDisplayFrame:frame];
        
        
        [actionFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"chicken%d.png",currentActionNum+1]]];
        [actionFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"chicken%d.png",(currentActionNum^1)+1]]];
        
        CGRect rect=[[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"chicken1.png"] rect];
        [self setContentSize:rect.size];
        
    }
    return self;
}
-(void)dealloc
{
    [self cleanup];
    [actionFrames release];
    [super dealloc]; 
}

- (void)startAction
{
    
    CCAnimation *actionAnimate = [CCAnimation animationWithFrames:actionFrames delay:0.7f]; 
    
    [self runAction:[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:actionAnimate restoreOriginalFrame:NO]]];
    
    float interval = [self randomRangeFrom:0.2f to:2.5f];
    [self schedule:@selector(doLogic:) interval:interval ];
    
    CCLOG(@"chicken %d startAction!! interval:%f",[self tag],interval);

}




- (void)setCallBackHost:(id)pHost method:(SEL)pMethod
{
    cbHost=pHost;
    cbMethod=pMethod;
}

- (void)doLogic:(ccTime)dt 
{
    [self unschedule:_cmd];
    ////////////

    float timePast = CFAbsoluteTimeGetCurrent()-gameStart;

    //
    //int maxPool = EGG_POOL_BASIC_SIZE+(timePast/EGGUP_INTERVAL);
    //每提昇一級加一顆蛋
    int maxPool = EGG_POOL_BASIC_SIZE+currentLevel;

    //如果目前蛋數量小於每n秒1顆 則改以時間n為計算方式
    if(maxPool<(EGG_POOL_BASIC_SIZE+(timePast/EGGUP_INTERVAL)) )
    {
        maxPool = EGG_POOL_BASIC_SIZE+(timePast/EGGUP_INTERVAL);
    }
    CCLOG(@"chicken:%d, timePast:%f/ start: %f / maxPool:%d ",[self tag],timePast,gameStart,maxPool);

    
    if(eggPool.poolCount<maxPool)
    {

        Egg *egg=[eggPool getFreeSprite];
        
        if(egg!=nil)
        {
            
            CCLOG(@"got --->> %@ ",[egg description]);
            int type = [self eggDecider];
            [egg startWithPositionX:self.position.x Y:EGG_STARTDROP_CENTER_Y duration:eggSpeed[type] type:type];
            [egg startFalling];
            
            
            CCLOG(@"poolcount: %d - check %d/%d, %@",eggPool.poolCount,[egg visible],[egg isFalling], egg.description);
            
        }
    }

    ////////////
    
    //出蛋間隔時間=10-LV*0.1sec
    

    int valRandom = arc4random() % (100);
    float actualInterval = 10-currentLevel*basiFormula;
    
    if(valRandom<USE_FORMULA_PROBA) actualInterval = [self randomRangeFrom:0.3 to:3];
    
    if(actualInterval<=0.1) actualInterval=0.1;

    [self schedule:_cmd interval:actualInterval];


}


- (float)randomRangeFrom:(float)num1 to:(float)num2
{
    float range = num2 - num1;
    float val = ((float)arc4random() / ARC4RANDOM_MAX) * range + num1;
    return val;
    
}



//eggDecider 決定這次是哪種蛋
- (int)eggDecider
{
    //return NOT_EGG_NUMBER;
    
    static int proba[EGG_TYPES+1]= { 0,
        EGG_PROBA_LV_1, 
        EGG_PROBA_LV_1+EGG_PROBA_LV_2, 
        EGG_PROBA_LV_1+EGG_PROBA_LV_2+EGG_PROBA_LV_3,
        EGG_PROBA_LV_1+EGG_PROBA_LV_2+EGG_PROBA_LV_3+EGG_PROBA_LV_4,
        EGG_PROBA_LV_1+EGG_PROBA_LV_2+EGG_PROBA_LV_3+EGG_PROBA_LV_4+EGG_PROBA_LV_5,
        EGG_PROBA_LV_1+EGG_PROBA_LV_2+EGG_PROBA_LV_3+EGG_PROBA_LV_4+EGG_PROBA_LV_5+EGG_PROBA_LV_6 };
    
    
    int valRandom = arc4random() % (100);
    
    //int arraySize = sizeof(proba)/sizeof(proba[0]);
    int indicator = 0;
    for (indicator=0; indicator<EGG_TYPES; indicator++) {
        if( (valRandom>proba[indicator]) && (valRandom<proba[indicator+1]) ) return indicator;
    }
    
    // CCLOG(@"valRandom:%d",valRandom);
    
    return 0;
}
@end
