//
//  GlobalVar.h
//  cc2dTest
//
//  Created by Chang Shun-Kuei on 4/22/12.
//  Copyright (c) 2012 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RestrictPool.h"
#import "GameManager.h"
#import "Defines.h"

#import "Farmer.h"
#import "AdRootViewController.h"
#import "Chronometer.h"

//@class RestrictPool;
extern RestrictPool     *eggPool;
//extern b2World         *_world;
//extern GLESDebugDraw   *_debugDraw;
extern Farmer           *farmer;

extern GameManager      *gameManager;
extern Chronometer      *watch;

extern CFTimeInterval gameStart;
//extern int playMinutes;
//extern int playSeconds;
extern BOOL isPause;
extern int scoredPoint;
extern int brokenEggCount;
extern int totalEggs;
//extern int catchCount;
//extern int catchEggs[EGG_TYPES];
//extern int generEggs[EGG_TYPES];

extern int scoredMapping[EGG_TYPES];
extern int eggSpeed[EGG_TYPES];

extern NSString *displayFont;
extern int displayFontSize;

extern float basiFormula;
extern int scoreUpgradeLV;
extern int currentLevel;
extern NSString *identifyUser;
//extern AdRootViewController	*admobVC;


/*
@interface GlobalVar : NSObject

@end
*/