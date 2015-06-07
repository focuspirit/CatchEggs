//
//  GameManager.m
//  cc2dTest
//
//  Created by Chang Shun-Kuei on 5/1/12.
//  Copyright (c) 2012 n/a. All rights reserved.
//

#import "SimpleAudioEngine.h"
#import "GameManager.h"
#import "GameScene.h"
#import "MenuScene.h"
#import "AboutScene.h"
#import "ScoreScene.h"
#import "GCHelper.h"
#import "GlobalVar.h"
#import "AppDelegate.h"

@implementation GameManager
SYNTHESIZE_SINGLETON_FOR_CLASS(GameManager);

@synthesize scores, actionMgr; //,currentLevel;

- (id)init
{
    
    if(self = [super init]) 
    {
        currentScene = kNoSceneUninitialized;
        scores = [[NSMutableArray alloc] init];
        actionMgr = [CCActionManager sharedManager];
    }    
    return self;
}

- (void)dealloc
{
    
    [scores release];
    [super dealloc];
}

- (void)runSceneWithID:(SceneTypes)sceneID 
{
    SceneTypes oldScene = currentScene;
    currentScene = sceneID;
    id sceneToRun = nil;
    
    switch (sceneID) {
        case kMainMenuScene:
            sceneToRun = [MenuScene scene];
            // CCLOG(@"kMainMenuScene");
            break;
        case kAboutScene:
            sceneToRun = [AboutScene scene];
            // CCLOG(@"kAboutScene");

            break;
        case kCreditsScene:
            sceneToRun = [ScoreScene scene];
            // CCLOG(@"kCreditsScene");

            break;
            
        case kGameScene:
            sceneToRun = [GameScene scene];
            
            // CCLOG(@"kGameScene");
            
            break;
        default:
            break;
        
    }
    if (sceneToRun == nil) {
        CCLOG(@"sceneToRun == nil");

        // Revert back, since no new scene was found
        currentScene = oldScene;
        
        return;
    }
    
    if ([[CCDirector sharedDirector] runningScene] == nil) 
    {
        CCLOG(@"runWithScene:sceneToRun");

        [[CCDirector sharedDirector] runWithScene:sceneToRun];
    } 
    else 
    {
        CCLOG(@"replaceScene:sceneToRun");

        [[CCDirector sharedDirector] replaceScene:sceneToRun];
    } 
}
  
- (void)loadScores 
{
 

    if([[NSUserDefaults standardUserDefaults] objectForKey:@"OurScores"] == nil) 
    {
        NSMutableDictionary *empty = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                      [NSNumber numberWithInt:0],@"score",
                                      [NSNumber numberWithInt:0],@"minutes",
                                      [NSNumber numberWithInt:0],@"seconds",
                                      [NSNumber numberWithInt:0],@"eggs",
                                      nil];

        
        for(int i=0;i<5;i++)
            [scores addObject:empty];
    } 
    else 
    {
        // CCLOG(@"Loading scores");
        scores = [[NSUserDefaults standardUserDefaults] objectForKey:@"OurScores"];
    }
    // CCLOG(@"scores: %@",scores);
}



-(void)saveScores:(int)scoredPoint miutes:(int)playMinutes seconds:(int)playSeconds
{
    
    // CCLOG(@"saveScores > %d:%d score:%d",playMinutes, playSeconds, scoredPoint);
    
    [self loadScores];
    
    
    NSMutableArray *newScores = [[NSMutableArray alloc] initWithArray:scores];
    
    
    for(int i=0; i<5;i++)
    {
        if([[[newScores objectAtIndex:i] objectForKey:@"score"] intValue] == scoredPoint)
        {
            break;
        }
        
        if([[[newScores objectAtIndex:i] objectForKey:@"score"] intValue] < scoredPoint) 
        {
            for(int j=5;j>i+1;j--) 
            {
                [newScores replaceObjectAtIndex:j-1 withObject:[scores objectAtIndex:j-2]];
            }
            
            NSMutableDictionary *newEntry = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                             [NSNumber numberWithInt:scoredPoint],@"score",
                                             [NSNumber numberWithInt:playMinutes],@"minutes",
                                             [NSNumber numberWithInt:playSeconds],@"seconds", 
                                             [NSNumber numberWithInt:totalEggs],@"eggs", 
                                             nil];
            [newScores replaceObjectAtIndex:i withObject:newEntry];
            break;
        }
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:newScores forKey:@"OurScores"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    
    [[GCHelper sharedGCHelper] reportScore:scoredPoint toLeaderboard:@"fotoespiritu.CatchEggs.score"];
    [[GCHelper sharedGCHelper] reportScore:((playMinutes*60)+playSeconds) toLeaderboard:@"fotoespiritu.CatchEggs.time"];
    [[GCHelper sharedGCHelper] reportScore:totalEggs toLeaderboard:@"fotoespiritu.CatchEggs.egg"];

    [newScores release];
    
}


@end
