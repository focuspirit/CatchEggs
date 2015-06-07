//
//  MainMenu.m
//  CatchEggs
//
//  Created by Chang Shun-Kuei on 3/16/12.
//  Copyright (c) 2012 n/a. All rights reserved.
//

#import "MainMenu.h"
#import "SimpleAudioEngine.h"
#import "GlobalVar.h"


@implementation MainMenu



- (id)initWithManager:(id)manager
{


    
    if([super initWithFrame:CGRectMake(0,0,480,320)])
    {
        RootManager = manager;
        
        
        self.image = [UIImage imageNamed:@"theme"];
        
        [self setUserInteractionEnabled:YES];
        self.backgroundColor = [UIColor redColor];

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
        NSDictionary *subdict =  [plistDict objectForKey:@"MainMenu"];

        for( id subKey in [subdict allKeys] )
        {
            //DLog(@"subKey: %@",subKey);
            NSDictionary *buttonProerty =  [subdict objectForKey:subKey];
            
            NSString *target = [buttonProerty objectForKey:@"Target"];
            //NSString *imgNormal = [buttonProerty objectForKey:@"NormalImage"];
            //NSString *imgPressed = [buttonProerty objectForKey:@"PresedImage"];
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


- (void)newGame:(id)sender
{
    [self playSound];
    [self removeFromSuperview];

    [gameManager runSceneWithID:kGameScene];

}



- (void)scoreBoard:(id)sender
{
    [self playSound];
    [self removeFromSuperview];
    
    [gameManager runSceneWithID:kCreditsScene];
}


- (void)aboutTheGame:(id)sender
{
    [self playSound];
    [self removeFromSuperview];
    
    [gameManager runSceneWithID:kAboutScene];

}

- (void) playSound {
    [[SimpleAudioEngine sharedEngine] playEffect:@"click.caf"];

}
@end
