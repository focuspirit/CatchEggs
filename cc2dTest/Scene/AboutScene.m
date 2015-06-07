//
//  AboutScene.m
//  cc2dTest
//
//  Created by Chang Shun-Kuei on 5/2/12.
//  Copyright (c) 2012 n/a. All rights reserved.
//

#import "cocos2d.h"
#import "AboutScene.h"

#import "AboutGame.h"

#import "AppDelegate.h"

@implementation AboutScene



AboutGame *aboutGame;
- (id)init
{
    if(self=[super init]) 
    {
        CCLOG(@"AS:init scene");

    }
    return self;
}


+ (id)scene 
{
    
    CCLOG(@"AS:load scene");
    CCScene *scene = [CCScene node];
    
    
    aboutGame = [[AboutGame alloc] initWithManager:self] ;
    
    [[[CCDirector sharedDirector] openGLView] addSubview:aboutGame]; 
    


    
    return scene;
}

- (void)dealloc 
{
    [aboutGame release];
    [super dealloc];
}


@end
