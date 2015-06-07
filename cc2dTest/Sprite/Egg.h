//
//  Egg.h
//  joypad
//
//  Created by Chang Shun-Kuei on 3/20/12.
//  Copyright (c) 2012 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "CCSprite.h"

#import "GlobalVar.h"


@interface Egg : CCSprite
{
    int     type;
    int     serial;
    
    int     duration;
    BOOL    isFalling;
    
    CFTimeInterval estimatedTime;
    CFTimeInterval lastDropTime;
    
    CFTimeInterval generateTime;
    
    CCAnimation *animateFalling;
    CGPoint endPosition;
    
    CCAction *fallAction;
    
    
}
@property (readonly) int type;
@property (readonly) int duration;

@property (readwrite) BOOL isFalling;

@property (readonly) int serial;
@property (readonly) CCAction *fallAction;
@property (readwrite) CGPoint endPosition;


- (void)startWithPositionX:(int)x Y:(int)y duration:(int)iDuration type:(int)eggType;


- (void)breakEgg;
- (void)dropDownHit;
- (void)startFalling;

- (NSString *)generateUuidString;

@end
