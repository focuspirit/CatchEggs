//
//  PauseView.m
//  CatchEggs
//
//  Created by Chang Shun-Kuei on 3/25/12.
//  Copyright (c) 2012 n/a. All rights reserved.
//

#import "PauseView.h"
#import "MainMenu.h"
#import "SimpleAudioEngine.h"

@implementation PauseView

- (id)initWithFrame:(CGRect)frame
{

    if ([super initWithFrame:frame]) {
        // Initialization code
        [self setUserInteractionEnabled:YES];

        self.backgroundColor = [UIColor blackColor];
        
        [self setAlpha:0.5f];

        playButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];

        
        CGSize imgSize = CGSizeMake(64, 64);
        

        
        playButton.frame = CGRectMake(110, 128, 260, imgSize.height);
        playButton.backgroundColor = [UIColor clearColor];
        
        //add shadow
        playButton.layer.shadowColor = [UIColor blackColor].CGColor;
        playButton.layer.shadowOpacity = 1.0;
        playButton.layer.shadowRadius = 5.0;
        playButton.layer.shadowOffset = CGSizeMake(0, 3);
        
        [playButton setImage:[UIImage imageNamed:@"button-play.png"] forState:UIControlStateNormal];

        [playButton setTitle:@"RESUME" forState:UIControlStateNormal];
        [playButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [playButton.titleLabel setFont:[UIFont boldSystemFontOfSize:36.0]];

        playButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0); //4個參數是上邊界，左邊界，下邊界，右邊界。

        playButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;

        [playButton addTarget:self action:@selector(clickPlay) forControlEvents:UIControlEventTouchUpInside];

        [self addSubview:playButton];

        
        
        restartButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        

        restartButton.frame = CGRectMake(110, 48, 260, imgSize.height);
        restartButton.backgroundColor = [UIColor clearColor];
        restartButton.layer.shadowColor = [UIColor blackColor].CGColor;
        restartButton.layer.shadowOpacity = 1.0;
        restartButton.layer.shadowRadius = 5.0;
        restartButton.layer.shadowOffset = CGSizeMake(0, 3);
        
        [restartButton setImage:[UIImage imageNamed:@"button-rotate-ccw.png"] forState:UIControlStateNormal];
        
        [restartButton setTitle:@"RESTART" forState:UIControlStateNormal];
        [restartButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [restartButton.titleLabel setFont:[UIFont boldSystemFontOfSize:36.0]];
        
        restartButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0); //4個參數是上邊界，左邊界，下邊界，右邊界。
        
        restartButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
        [restartButton addTarget:self action:@selector(clickRestart) forControlEvents:UIControlEventTouchUpInside];

        
        [self addSubview:restartButton];

    }
    return self;
}

- (void)dealloc
{
    
    
    [super dealloc];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)regesterPlayButtonWithTarget:(id)target action:(SEL)action
{
    
    playTarget = target;
    playAction = action;
    
   
}
- (void)regesterRestartButtonWithTarget:(id)target action:(SEL)action
{
    
    restartTarget = target;
    restartAction = action;
}

- (void)clickPlay
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"click.caf"];

    
    if([playTarget respondsToSelector:playAction]) {
        
        [playTarget performSelector:playAction];

    }
}
- (void)clickRestart
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"click.caf"];

    if([restartTarget respondsToSelector:restartAction]) {

        [restartTarget performSelector:restartAction];
    }
}


@end
