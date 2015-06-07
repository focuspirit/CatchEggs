//
//  ScoreScene.m
//  cc2dTest
//
//  Created by Chang Shun-Kuei on 5/2/12.
//  Copyright (c) 2012 n/a. All rights reserved.
//
#import "cocos2d.h"
#import "ScoreScene.h"

#import "ScoreBoard.h"
@implementation ScoreScene


ScoreBoard *scoreBoard;
- (id)init
{
    if(self=[super init]) 
    {
    }
    return self;
}


+ (id)scene 
{
    
    CCLOG(@"AS:load scene");
    CCScene *scene = [CCScene node];
    
    
    scoreBoard = [[ScoreBoard alloc] initWithManager:self] ;
    
    [[[CCDirector sharedDirector] openGLView] addSubview:scoreBoard]; 
    
    return scene;
}

- (void)dealloc 
{
    [scoreBoard release];
    [super dealloc];
}


@end
