//
//  ScoreBoard.m
//  CatchEggs
//
//  Created by Chang Shun-Kuei on 3/19/12.
//  Copyright (c) 2012 n/a. All rights reserved.
//

#import "ScoreBoard.h"
#import "MainMenu.h"
#import "SimpleAudioEngine.h"
@implementation ScoreBoard

- (id)initWithManager:(id)manager
{
    if([super initWithFrame:CGRectMake(0,0,480,320)])
    {

        RootManager = manager;


        self.backgroundColor = [UIColor grayColor];

        self.image = [UIImage imageNamed:@"scoreboard"];
        
        
        [self setUserInteractionEnabled:YES];
        

        //讀取plist文件並轉化為NSDictionary
        NSPropertyListFormat format;
        NSString *error = nil;

        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"MenuButtonProperty" ofType:@"plist"];
        
        //DLog("plistPath: %@ ",plistPath);
        
        NSData *plist = [[NSFileManager defaultManager] contentsAtPath:plistPath];
        
        NSDictionary *plistDict = (NSDictionary *)
        
        [NSPropertyListSerialization propertyListFromData:plist
                                         mutabilityOption:NSPropertyListMutableContainersAndLeaves
                                                   format:&format errorDescription:&error];
        //
        NSDictionary *subdict =  [plistDict objectForKey:@"ScoreMenu"];
        
        for( id subKey in [subdict allKeys] )
        {

            NSDictionary *buttonProerty =  [subdict objectForKey:subKey];
            
            NSString *target = [buttonProerty objectForKey:@"Target"];

            NSNumber *OriginX = [buttonProerty objectForKey:@"OriginX"];
            NSNumber *OriginY = [buttonProerty objectForKey:@"OriginY"];
            NSNumber *SizeX = [buttonProerty objectForKey:@"SizeX"];
            NSNumber *SizeY = [buttonProerty objectForKey:@"SizeY"];
            NSString *icon = [buttonProerty objectForKey:@"Icon"];
            
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            button.backgroundColor = [UIColor clearColor];

            
            button.alpha = 0.7f;
            button.frame = CGRectMake([OriginX intValue], [OriginY intValue], [SizeX intValue], [SizeY intValue]);
            //add shadow
            button.layer.shadowColor = [UIColor blackColor].CGColor;
            button.layer.shadowOpacity = 1.0;
            button.layer.shadowRadius = 5.0;
            button.layer.shadowOffset = CGSizeMake(0, 3);
            button.highlighted = NO;
            
            [button setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
            
            [button setTitle:subKey forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            [button.titleLabel setFont:[UIFont fontWithName:displayFont size:displayFontSize]];
            
            button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0); //4個參數是上邊界，左邊界，下邊界，右邊界。
            ////
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            
            SEL sel=NSSelectorFromString(target);
            
            [button addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
            
            [self addSubview:button];
            [gameManager loadScores];
            
            for(int i=0; i<5; i++)
            {
                int score = [[[gameManager.scores objectAtIndex:i] objectForKey:@"score"] intValue];
                int minutes = [[[gameManager.scores objectAtIndex:i] objectForKey:@"minutes"] intValue];
                int seconds = [[[gameManager.scores objectAtIndex:i] objectForKey:@"seconds"] intValue];
                int eggs = [[[gameManager.scores objectAtIndex:i] objectForKey:@"eggs"] intValue];
                
                UILabel *labelScore = [[UILabel alloc] initWithFrame:CGRectMake(85, 85+(i*25), 400, 25)];
                
                [labelScore setText:[NSString stringWithFormat:@"%02d. %02d:%02d Score:%05d Eggs:%03d", i+1, minutes, seconds, score,eggs] ];
   

                [labelScore setFont:[UIFont fontWithName:@"HiraKakuProN-W6" size:18]];
                [labelScore setTextColor:[UIColor blackColor]];
                [labelScore setAlpha:1.0];

                [labelScore setBackgroundColor:[UIColor clearColor]];
                [labelScore setTextAlignment:UITextAlignmentLeft];
                labelScore.shadowColor = [UIColor whiteColor];
                labelScore.shadowOffset = CGSizeMake(0, 1);
                [self addSubview:labelScore];
                [labelScore release];
            
            }
            
            
        }
    }
    return self;
}


- (void)dealloc
{
    
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code


    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    // Drawing code
    
}


- (void)backMain:(id)sender
{
    [self playSound];
    //[RootManager doStateChange:[MainMenu class]];
    [self removeFromSuperview];
    
    [gameManager runSceneWithID:kMainMenuScene];
}


- (void) playSound {
    [[SimpleAudioEngine sharedEngine] playEffect:@"click.caf"];

} 
@end
