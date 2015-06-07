//
//  OverView.h
//  CatchEggs
//
//  Created by Chang Shun-Kuei on 3/25/12.
//  Copyright (c) 2012 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "GlobalVar.h"


@interface OverView : UIView
{
    UIButton *restartButton;
    id  restartTarget;
    SEL restartAction;
}

- (void)regesterRestartButtonWithTarget:(id)target action:(SEL)action;
- (void)setTimeText:(NSString *)text;
- (void)setScoreText:(NSString *)text;
- (void)setEggsText:(NSString *)text;
@end
