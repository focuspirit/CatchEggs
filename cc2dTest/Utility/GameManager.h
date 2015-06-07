//
//  GameManager.h
//  cc2dTest
//
//  Created by Chang Shun-Kuei on 5/1/12.
//  Copyright (c) 2012 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SynthesizeSingleton.h"
#import "cocos2d.h"
#import "Defines.h"

//#import "PauseView.h"

typedef enum {
    kNoSceneUninitialized=0,
    kMainMenuScene=1,
    //kOptionsScene=2,
    kAboutScene=2,
    kCreditsScene=3,
    kGameScene=4,
} SceneTypes;


@interface GameManager : NSObject
{
    NSMutableArray *scores;

    SceneTypes currentScene;
    //float basiFormula;
    //int scoreUpgradeLV;
    CCActionManager *actionMgr;

}
@property (retain, readonly) NSMutableArray *scores;
@property (readonly) CCActionManager *actionMgr;




//@property (readwrite) int currentLevel;

+ (GameManager *)sharedGameManager;
- (void)runSceneWithID:(SceneTypes)sceneID;
- (void)loadScores;
- (void)saveScores:(int)scoredPoint miutes:(int)playMinutes seconds:(int)playSeconds;

@end
