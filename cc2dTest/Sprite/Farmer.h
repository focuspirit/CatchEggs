//
//  Farmer.h
//  cc2dTest
//
//  Created by Chang Shun-Kuei on 4/13/12.
//  Copyright (c) 2012 n/a. All rights reserved.
//
#import <UIKit/UIKit.h>

#import "cocos2d.h"
#import "CCSprite.h"
#import "CCActionManager.h"

//判斷是否接觸到的區域，以原圖尺寸內縮的差距(皆為正數)
#define FARMER_DETECT_OFFSET_TOP        0
#define FARMER_DETECT_OFFSET_BOTTOM     80
#define FARMER_DETECT_OFFSET_RIGHT      0
#define FARMER_DETECT_OFFSET_LEFT       0

//判斷是否接觸到的區域，以原圖尺寸內縮的差距(皆為正數) 需以上下顛倒算
#define FARMER_HITDETECT_OFFSET_TOP        20
#define FARMER_HITDETECT_OFFSET_BOTTOM     5
#define FARMER_HITDETECT_OFFSET_RIGHT      5
#define FARMER_HITDETECT_OFFSET_LEFT       0

enum { TS_NONE, TS_TAP, TS_HOLD, TS_DRAG };

@interface Farmer : CCSprite
{
 
    float holdTime;     //How long have we held down on this?
    int touchedState;   //Current touched state
    bool isTouched;     //Are we touching this currently?
    
    float lastMoved;        //How long has it been since we moved this?
    CGPoint lastTouchedPoint;  //Where did we last touch?
    CGRect  catchBox;
    CGRect  hitBox;
    /*
    const float releaseThreshold = 1.0f; //How long before we recognize a release
    const float holdThreshold = 0.2f; //How long before a tap turns into a hold
    const float lastMovedThreshold = 0.5f; //How long before we consider you to be 'not moving'
    const int dragThreshold = 3; //We have a drag threshold of 3 pixels.
    */
    NSMutableArray *frameMarch;
    CCAnimation *animateMarch;
    CCAction *marchAction;

}
@property (readonly) CGRect catchBox;
@property (readonly) CGRect hitBox;


- (void)actionMarch;
- (void)actionHit;
- (void)startAction;
- (void)updatCatchBox;
- (void)touch:(BOOL)flag;

@end
