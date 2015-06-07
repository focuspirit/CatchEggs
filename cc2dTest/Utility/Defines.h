//
//  Defines.h.h
//  CatchEggs
//
//  Created by Chang Shun-Kuei on 5/6/12.
//  Copyright (c) 2012 n/a. All rights reserved.
//


#ifndef CatchEggs_Defines_h
#define CatchEggs_Defines_h

#define GLToUI(_X_, _Y_) [[CCDirector sharedDirector] convertToUI:  ccp(_X_, _Y_)]


#define EGG_POOL_BASIC_SIZE     2   //基本最少數量
#define MAX_POOL_EGGS           15  //最多pool蛋數量
#define EGGUP_INTERVAL          60  //最少應該每幾秒增加一個蛋
#define USE_FORMULA_PROBA       70  //生蛋間隔時間使用公式的機率

#define ARC4RANDOM_MAX      0x100000000ULL
#define CHICKEN_START_X     95
#define CHICKEN_START_Y     50
#define CHICKEN_SPACE       20

#define EGGDROP_ESTTIME         2   //蛋掉落時間長度
#define EGG_DROP_SPEED          1   //蛋掉落速度
#define EGG_STARTDROP_CENTER_Y  120 //開始掉落的高度
#define EGG_ENDDROP_CENTER_Y    320 //

#define EGG_TYPES               6       //蛋的總類數
#define NOT_EGG_NUMBER          5       //from zero = 6
#define MAX_BROKEN_EGGS         4       //破幾顆蛋算GameOver, from zero count = 5

//各種蛋的得分表
#define EGG_POINT_LV_1  13			//白
#define EGG_POINT_LV_2  35			//棕
#define EGG_POINT_LV_3  100			//藍
#define EGG_POINT_LV_4  250          //銀
#define EGG_POINT_LV_5  1000          //金
#define EGG_POINT_LV_6  -500         //大便

//各種蛋的機率表 合計為100%
#define EGG_PROBA_LV_1  40		//白
#define EGG_PROBA_LV_2  19		//棕
#define EGG_PROBA_LV_3  10		//藍
#define EGG_PROBA_LV_4   8		//銀
#define EGG_PROBA_LV_5   3		//金
#define EGG_PROBA_LV_6  20		//大便

//各種蛋的速度表(秒)
#define EGG_SPEED_LV_1  2		//白
#define EGG_SPEED_LV_2  2		//棕
#define EGG_SPEED_LV_3  1.8		//藍
#define EGG_SPEED_LV_4  1.5		//銀
#define EGG_SPEED_LV_5  1		//金
#define EGG_SPEED_LV_6  2		//大便

typedef enum
{
    EggType_Normal ,
    EggType_Brown,
    EggType_Blue,
    EggType_Sliver,
    EggType_Gold,
    EggType_Feces
} EggTypeTags;

#define PAUSE_BUTTON_TAG    0100
#define CHICKEN_TAG_BEGIN   1000
#define EGG_TAG_BEGIN       2000

#endif
