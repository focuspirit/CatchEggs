//
//  PlayLayer.h
//  cc2dTest
//
//  Created by Chang Shun-Kuei on 4/16/12.
//  Copyright (c) 2012 n/a. All rights reserved.
//


//#import "cocos2d.h"
#import "CCLayer.h"

#import "AdWhirlDelegateProtocol.h"
#import "AdWhirlView.h"
#import "Apon.h"


#import "PauseView.h"
#import "OverView.h"
#import "Chronometer.h"
#define degreesToRadians(x) (M_PI * x / 180.0)

#define HORIZ_SWIPE_DRAG_MIN 3
#define VERT_SWIPE_DRAG_MAX 20

@interface PlayLayer : CCLayer <AdWhirlDelegate> 
{
    CGPoint startTouchPosition;
    CGPoint currentTouchPosition;
    CGPoint endedTouchPosition;
    
    NSString *direction;
    CGSize winSize;

    CCLabelBMFont   *lableScored;
    CCLabelBMFont   *lableEggs;

    
    CFTimeInterval  pauseStart;
    PauseView       *pauseView;
    OverView        *overView;

    int             displayBrokenEggs;
    int             nextUpgradeScore;
	CCLabelBMFont    *lvFormula;

    Chronometer *watch;
    AdWhirlView *awView; 
    UIViewController *viewController; 
}
@property (nonatomic,retain) AdWhirlView *awView; 

- (void)countdown;


@end
