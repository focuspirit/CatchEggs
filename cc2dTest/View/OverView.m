//
//  OverView.m
//  CatchEggs
//
//  Created by Chang Shun-Kuei on 3/25/12.
//  Copyright (c) 2012 n/a. All rights reserved.
//
#import "SimpleAudioEngine.h"
#import "OverView.h"
#import "GlobalVar.h"

@implementation OverView

typedef enum
{
    UI_Label_Title ,
    UI_Label_Time,
    UI_Label_Score,
    UI_Label_Eggs,
    UI_Button_Restart
} UI_Tags;



- (id)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {

        // Initialization code
        [self setUserInteractionEnabled:YES];
        //self.backgroundColor = [UIColor redColor];
        self.backgroundColor = [UIColor blackColor];
        
        [self setAlpha:0.7f];
        
        
        UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 460, 64)];
        [labelTitle setText:@"GAME OVER"];
        [labelTitle setFont:[UIFont boldSystemFontOfSize:64.0]];
        [labelTitle setTextColor:[UIColor whiteColor]];
        [labelTitle setBackgroundColor:[UIColor clearColor]];
        [labelTitle setTextAlignment:UITextAlignmentCenter];
        labelTitle.tag = UI_Label_Title;
        [self addSubview:labelTitle];
        [labelTitle release];
        
        
        UILabel *labelTime = [[UILabel alloc] initWithFrame:CGRectMake(10, 100, 460, 36)];

        [labelTime setText:@"" ];
        [labelTime setFont:[UIFont fontWithName:@"Helvetica" size:28]];
        [labelTime setTextColor:[UIColor whiteColor]];
        [labelTime setBackgroundColor:[UIColor clearColor]];
        [labelTime setTextAlignment:UITextAlignmentCenter];
        labelTime.shadowColor = [UIColor blackColor];
        labelTime.shadowOffset = CGSizeMake(0, 1);
        labelTime.tag = UI_Label_Time;
        [self addSubview:labelTime];
        [labelTime release];
        
        
        UILabel *labelScore = [[UILabel alloc] initWithFrame:CGRectMake(10, 130, 460, 36)];

        [labelScore setText:@""];
        [labelScore setFont:[UIFont fontWithName:@"Helvetica" size:28]];
        [labelScore setTextColor:[UIColor whiteColor]];
        [labelScore setBackgroundColor:[UIColor clearColor]];
        [labelScore setTextAlignment:UITextAlignmentCenter];
        labelScore.shadowColor = [UIColor blackColor];
        labelScore.shadowOffset = CGSizeMake(0, 1);
        labelScore.tag = UI_Label_Score;
        [self addSubview:labelScore];
        [labelScore release];

        UILabel *labelEggs = [[UILabel alloc] initWithFrame:CGRectMake(10, 160, 460, 36)];

        [labelEggs setText:@""];
        [labelEggs setFont:[UIFont fontWithName:@"Helvetica" size:28]];
        [labelEggs setTextColor:[UIColor whiteColor]];
        [labelEggs setBackgroundColor:[UIColor clearColor]];
        [labelEggs setTextAlignment:UITextAlignmentCenter];
        labelEggs.shadowColor = [UIColor blackColor];
        labelEggs.shadowOffset = CGSizeMake(0, 1);
        labelEggs.tag = UI_Label_Eggs;
        [self addSubview:labelEggs];
        [labelEggs release];
        
        
        CGSize imgSize = CGSizeMake(64, 64);
        restartButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        
        
        restartButton.frame = CGRectMake(110, 220, 260, imgSize.height);
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
        restartButton.tag = UI_Button_Restart;
        
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


- (void)setTimeText:(NSString *)text
{
    [(UILabel *)[self viewWithTag:UI_Label_Time] setText:text];
        
}
- (void)setScoreText:(NSString *)text
{
    [(UILabel *)[self viewWithTag:UI_Label_Score] setText:text];
    
}
- (void)setEggsText:(NSString *)text
{
    [(UILabel *)[self viewWithTag:UI_Label_Eggs] setText:text];
    
}



- (void)clickRestart
{
    if([restartTarget respondsToSelector:restartAction]) {
        [self playSound];
        [self playThemeMusic];
        [restartTarget performSelector:restartAction];
    }
}

- (void)regesterRestartButtonWithTarget:(id)target action:(SEL)action
{
    restartTarget = target;
    restartAction = action;  
}

- (void) playSound {
    [[SimpleAudioEngine sharedEngine] playEffect:@"click.caf"];

} 
- (void)playGameOverMusic
{
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"gameover.m4a" loop:NO];

    
}
- (void)playThemeMusic
{
    
}
@end
