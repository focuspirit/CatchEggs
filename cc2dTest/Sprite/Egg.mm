//
//  Egg.m
//  joypad
//
//  Created by Chang Shun-Kuei on 3/20/12.
//  Copyright (c) 2012 n/a. All rights reserved.
//

#import "Egg.h"
#import "SimpleAudioEngine.h"
@implementation Egg

@synthesize type, serial, fallAction, isFalling, endPosition, duration;

static NSString *imgEggNamed[] = { @"egg1.png", @"egg2.png", @"egg3.png", @"egg4.png", @"egg5.png", @"egg6.png" };


- (id)init
{
    if (self = [super init]) {
        [self setVisible:NO];
        isFalling=NO;
        position_=CGPointZero;

        //[self cleanup];
    }
    return self;
}




- (void)startWithPositionX:(int)x Y:(int)y duration:(int)iDuration type:(int)eggType
{

    type = eggType;
    
    CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:imgEggNamed[type]];
    [self setDisplayFrame:frame];
    serial = [eggPool refrashSprite:self];

    duration = iDuration;

    
    [self setPosition:GLToUI(x,y)];

    endPosition =GLToUI(self.position.x, EGG_ENDDROP_CENTER_Y);
    
    
     fallAction = [CCSequence actions:
                   [CCEaseOut actionWithAction:[CCMoveTo actionWithDuration:duration position: endPosition] rate:0.4],
                   [CCCallFunc actionWithTarget:self selector:@selector(breakEgg)], 
                   nil];
     

    
    [self setVisible:YES];

    isFalling = NO;
    
    [self schedule:@selector(dropDownHit)];
    
    CCLOG(@"%d - complieted startWithPosition:%@",serial,[self description]);    

}





- (void)startFalling
{

    // CCLOG(@"startFalling %d:%d:%d %@ -> %@",serial,duration,self.isRunning, NSStringFromCGPoint(self.position),NSStringFromCGPoint(endPosition));

    [self runAction:fallAction];
    isFalling = YES;
    // CCLOG(@"startFalling Thread:%@", [NSThread currentThread]);
    
}


-(void)breakEgg
{
    BOOL result=[eggPool disappearSprite:self];
    
    if(!result) CCLOG(@"ERROR!!! ");
    [self unschedule:@selector(dropDownHit)];
    
    if(type!=NOT_EGG_NUMBER)    brokenEggCount++;

    
    isFalling=NO;
}


-(void)dealloc
{
    [self cleanup];
    [super dealloc]; 
}

- (void)dropDownHit
{

    BOOL    hitGot = NO;
    
    if(type==NOT_EGG_NUMBER)
    {
        if(CGRectIntersectsRect(self.boundingBox,farmer.hitBox))
        {
            [farmer actionHit];
            hitGot = YES;
            
        }
    }
    else {
        if(CGRectIntersectsRect(self.boundingBox,farmer.catchBox))
        {
            totalEggs++;
            hitGot = YES;
            // CCLOG(@"%d - GOT!!<%@><%@>",serial,NSStringFromCGRect(self.boundingBox),NSStringFromCGRect(farmer.catchBox));

            
        }

    }
    
    if(hitGot==YES)
    {
        [[SimpleAudioEngine sharedEngine] playEffect:@"catch.caf"];

        [self stopAction:fallAction];   //暫停所有動作處理
        [eggPool disappearSprite:self];
        [self unschedule:_cmd];
        isFalling=NO;
        
        scoredPoint += scoredMapping[type];
        
        if(scoredPoint<=0) scoredPoint=0;
    }
    
        
}

@end
