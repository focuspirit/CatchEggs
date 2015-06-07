//
//  Chicken.h
//  cc2dTest
//
//  Created by Chang Shun-Kuei on 4/21/12.
//  Copyright (c) 2012 n/a. All rights reserved.
//
#import "cocos2d.h"
#import "CCSprite.h"

#import "GlobalVar.h"


@interface Chicken : CCSprite
{
    id     cbHost;
    SEL    cbMethod;
    NSMutableArray *actionFrames;
}
- (float)randomRangeFrom:(float)num1 to:(float)num2;
- (void)setCallBackHost:(id)pHost method:(SEL)pMethod;
- (int)eggDecider;
- (void)startAction;

@end
