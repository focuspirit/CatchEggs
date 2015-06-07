//
//  GameScene.h
//  cc2dTest
//
//  Created by Chang Shun-Kuei on 4/12/12.
//  Copyright (c) 2012 n/a. All rights reserved.
//

//#import "cocos2d.h"
//#import "CCScene.h"


#import "BackgroundLayer.h"
#import "PlayLayer.h"



@interface GameScene : CCScene 
{
    BackgroundLayer *backgroundLayer;
    PlayLayer *playLayer;
    

}

+ (id)scene;

@end
