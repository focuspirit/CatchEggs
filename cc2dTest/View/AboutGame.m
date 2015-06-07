//
//  AboutGame.m
//  CatchEggs
//
//  Created by Chang Shun-Kuei on 3/19/12.
//  Copyright (c) 2012 n/a. All rights reserved.
//

#import "AboutGame.h"
#import "GameManager.h"
#import "SimpleAudioEngine.h"
#import "AppDelegate.h"
#import "GCHelper.h"
#import "UIDevice+machine.h"

@implementation AboutGame

- (id)initWithManager:(id)manager
{
    if([super initWithFrame:CGRectMake(0,0,480,320)])
    {
        RootManager = manager;

        self.backgroundColor = [UIColor grayColor];

        self.image = [UIImage imageNamed:@"aboutGame"];
        
        
        [self setUserInteractionEnabled:YES];
        

        //讀取plist文件並轉化為NSDictionary
        NSPropertyListFormat format;
        NSString *error = nil;

        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"MenuButtonProperty" ofType:@"plist"];
        
        
        NSData *plist = [[NSFileManager defaultManager] contentsAtPath:plistPath];
        
        NSDictionary *plistDict = (NSDictionary *)
        
        [NSPropertyListSerialization propertyListFromData:plist
                                         mutabilityOption:NSPropertyListMutableContainersAndLeaves
                                                   format:&format errorDescription:&error];
        //
        NSDictionary *subdict =  [plistDict objectForKey:@"AboutMenu"];
        
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

            //////////////
            
            UILabel *switchLabel = [[UILabel alloc] initWithFrame:CGRectMake(255, 100, 185, 30)];
            switchLabel.text=@"Mute Music&Sound";
            switchLabel.textAlignment = UITextAlignmentCenter;
            switchLabel.backgroundColor = [UIColor clearColor];
            [self addSubview:switchLabel];
            [switchLabel release];
            
            UISwitch *muteSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(310, 130, 0, 0)];
            [muteSwitch addTarget:self action:@selector(muteChanged:) forControlEvents:UIControlEventValueChanged];
            [muteSwitch setOn: UIAppDelegate.isMute];
            [muteSwitch setTag:1];

            [self addSubview:muteSwitch];

            [muteSwitch release];

            UILabel *labelGC = [[UILabel alloc] initWithFrame:CGRectMake(255, 170, 185, 30)];
            labelGC.text=@"Upload Score";
            labelGC.textAlignment = UITextAlignmentCenter;
            labelGC.backgroundColor = [UIColor clearColor];
            [self addSubview:labelGC];
            [labelGC release];
            
            UISwitch *switchGC = [[UISwitch alloc] initWithFrame:CGRectMake(310, 200, 0, 0)];
            [switchGC addTarget:self action:@selector(gcChanged:) forControlEvents:UIControlEventValueChanged];
            [switchGC setOn: [GCHelper sharedGCHelper].uploadScore];
             
            [switchGC setEnabled:[GCHelper sharedGCHelper].gameCenterAvailable];
            
            CCLOG(@"userAuthenticated:%d /networkReachability:%d",[GCHelper sharedGCHelper].userAuthenticated,[UIDevice networkReachability]);
            
            
            [switchGC setTag:2];
            
            [self addSubview:switchGC];
            
            [switchGC release];
            

            [[NSNotificationCenter defaultCenter] addObserver: self
                                                     selector: @selector(networkReachabilityChanged)
                                                         name: kAuthenticationChanged
                                                       object: nil];    
        }
    }
    return self;
}

- (void)dealloc
{
    [secondsField release];
    [scoredsField release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];

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
    ///////////////
    if(secondsField.text.length>0)    basiFormula= [secondsField.text floatValue];

    if(scoredsField.text.length>0)   scoreUpgradeLV = [scoredsField.text intValue];
    
    
    
    ///////////////
    
    [self playSound];
    //[RootManager doStateChange:[MainMenu class]];
    [self removeFromSuperview];
    
    [gameManager runSceneWithID:kMainMenuScene];

}

- (void) playSound 
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"click.caf"];

}

#define NUMBERS @".0123456789\n"
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSCharacterSet *cs;       
    //if(textField == secondsField)
    {
        cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS] invertedSet];       
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];       
        BOOL basicTest = [string isEqualToString:filtered];
        if(!basicTest)
        {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"請輸入數字"
                                                           delegate:nil
                                                  cancelButtonTitle:@"確定"
                                                  otherButtonTitles:nil];
            
            [alert show];
            [alert release];
            return NO;
        }   
    }
    
    //其他的類型不需要檢測，直接寫入
    return YES;    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    //CCLOG(@"test:%@",textField.text);
    
    return YES;
}

- (void)muteChanged:(id)sender
{
    UISwitch *switchMute=(UISwitch *)sender;

    
    [[SimpleAudioEngine sharedEngine] setMute:switchMute.isOn];
    [UIAppDelegate setIsMute:switchMute.isOn];
    
}

- (void)gcChanged:(id)sender
{
    UISwitch *gcSwitch=(UISwitch *)sender;
    
    
    if(gcSwitch.isOn==YES)
    {
        [[GCHelper sharedGCHelper] authenticateLocalUser]; 
        
    }
    else {
        [GCHelper sharedGCHelper].uploadScore=NO;
    }
    
    
}

- (void)networkReachabilityChanged
{

    [((UISwitch *)[self viewWithTag:2]) setOn:[GCHelper sharedGCHelper].uploadScore animated:YES];
    
}




@end
