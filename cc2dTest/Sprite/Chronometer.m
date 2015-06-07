//
//  Chronometer.m
//  CatchEggs
//
//  Created by Chang Shun-Kuei on 5/6/12.
//  Copyright (c) 2012 n/a. All rights reserved.
//

#import "Chronometer.h"
#import "Defines.h"

@implementation Chronometer
@synthesize playStart, playMinutes, playSeconds;


- (id)init
{
    if (self = [super init]) {
        [self setVisible:NO];
        isPause=NO;
        playMinutes = 0;
        playSeconds = 0;
    }
    return self;
}



- (void)dealloc
{

[self cleanup];
    [super dealloc];
}


- (void)startWithPositionX:(int)x Y:(int)y
{
    
    [self setVisible:YES];
    
    
    CCSprite *timer = [CCSprite spriteWithFile:@"clock_back.png"];
    [timer setPosition:GLToUI(x, y)];
    [self addChild:timer z:0];
    
    
    CCProgressFromTo *to1 = [CCProgressFromTo actionWithDuration:60.0f from:100 to:0];
    watch = [CCProgressTimer progressWithFile:@"clock_front.png"];
    
    watch.type=kCCProgressTimerTypeRadialCCW;
    [watch setPosition:GLToUI(x, y)];

    [watch runAction: [CCRepeatForever actionWithAction: to1] ];
    
    [self addChild:watch z:1];
    
    
    lableTime = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"%02d", playMinutes] fntFile:@"Bebas.fnt"];
    
    [lableTime setPosition:GLToUI(x, y)];
    [self addChild: lableTime z:2]; 

    playStart = CFAbsoluteTimeGetCurrent();

    // CCLOG(@">>playStart:%f",playStart);
    
    [self schedule:@selector(update:) interval:0.1f];

    

}

- (void)pauseClock
{
    pauseStart = CFAbsoluteTimeGetCurrent();
    isPause = YES;
}

- (void)resumeClock
{
    CFTimeInterval pausePast = CFAbsoluteTimeGetCurrent()-pauseStart;
    playStart += pausePast;
    isPause = NO;
}


-(void)update:(ccTime)delta
{
    if(playStart>0) 
    {    
        float timeElapsed;
        if(isPause)
        {
            timeElapsed = pauseStart -playStart;
        }
        else {
            timeElapsed = CFAbsoluteTimeGetCurrent()-playStart;
            
        }
        
        if (timeElapsed>0) {
            
            playMinutes = floor(timeElapsed/60);
            playSeconds = round(timeElapsed - playMinutes * 60);
            [lableTime setString:[NSString stringWithFormat:@"%02d", playMinutes]];

        }
    }
}



- (NSString *)pastTimeToStirng
{

    return [NSString stringWithFormat:@"%02d:%02d", playMinutes,playSeconds];

    
}

@end
