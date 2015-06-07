//
//  PauseView.h
//  CatchEggs
//
//  Created by Chang Shun-Kuei on 3/25/12.
//  Copyright (c) 2012 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface PauseView : UIView
{

    UIButton *playButton;
    UIButton *restartButton;

    id  playTarget;
    SEL playAction;
    
    id  restartTarget;
    SEL restartAction;
    
}

- (void)regesterPlayButtonWithTarget:(id)target action:(SEL)action;
- (void)regesterRestartButtonWithTarget:(id)target action:(SEL)action;

@end
