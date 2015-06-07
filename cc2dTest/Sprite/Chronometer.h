//
//  Chronometer.h
//  CatchEggs
//
//  Created by Chang Shun-Kuei on 5/6/12.
//  Copyright (c) 2012 n/a. All rights reserved.
//
#import "cocos2d.h"
#import "CCSprite.h"

@interface Chronometer : CCNode
{
    CCProgressTimer *watch;
    CCLabelBMFont   *lableTime;
    CFTimeInterval  playStart;
    CFTimeInterval  pauseStart;
    BOOL            isPause;
    int playMinutes;
    int playSeconds;

}
@property (readonly) CFTimeInterval  playStart;
@property (readonly) int  playMinutes;
@property (readonly) int  playSeconds;

- (void)startWithPositionX:(int)x Y:(int)y;
- (void)pauseClock;
- (void)resumeClock;

- (NSString *)pastTimeToStirng;

@end
