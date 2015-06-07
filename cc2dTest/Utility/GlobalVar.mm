//
//  GlobalVar.m
//  cc2dTest
//
//  Created by Chang Shun-Kuei on 4/22/12.
//  Copyright (c) 2012 n/a. All rights reserved.
//

#import "GlobalVar.h"
//#import "GameManager.h"

#import "GameScene.h"


RestrictPool    *eggPool;
//b2World         *_world;
//GLESDebugDraw   *_debugDraw;
Farmer          *farmer;
GameScene       *gameScene; 
GameManager     *gameManager;
Chronometer     *watch;

CFTimeInterval gameStart;

BOOL isPause;
int scoredPoint;
int totalEggs;
int brokenEggCount;


int scoredMapping[] = { EGG_POINT_LV_1, EGG_POINT_LV_2, EGG_POINT_LV_3, EGG_POINT_LV_4, EGG_POINT_LV_5, EGG_POINT_LV_6 };
int eggSpeed[] = {EGG_SPEED_LV_1, EGG_SPEED_LV_2, EGG_SPEED_LV_3, EGG_SPEED_LV_4, EGG_SPEED_LV_5, EGG_SPEED_LV_6 };


NSString *displayFont;
int displayFontSize;

float basiFormula=0.1;
int scoreUpgradeLV=250;
int currentLevel;
NSString *identifyUser;

