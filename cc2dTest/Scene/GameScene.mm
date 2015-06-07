//
//  GameScene.m
//  cc2dTest
//
//  Created by Chang Shun-Kuei on 4/12/12.
//  Copyright (c) 2012 n/a. All rights reserved.
//

#import "GameScene.h"
#import "AppDelegate.h"
#import "AdRootViewController.h"

@implementation GameScene

- (id)init
{
    if( (self=[super init])) {




    }   

    return self;
}



+ (id)scene 
{
    CCLOG(@"GS:load scene");
    
    CCScene* scene = [CCScene node];
    
    
    CCSpriteFrameCache* frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
    
    [frameCache addSpriteFramesWithFile:@"sprites.plist"];
    
    BackgroundLayer *backgroundLayer = [BackgroundLayer node];
    [backgroundLayer wallpaperFromImage:@"GameScene.png"];
    PlayLayer *playLayer = [PlayLayer node];
    
    [scene addChild:backgroundLayer z:1];
    [scene addChild:playLayer z:1]; 


    
    return scene;
}

- (void)dealloc {

    [super dealloc];
}



@end
