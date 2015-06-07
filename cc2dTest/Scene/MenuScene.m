//
//  MenuScene.m
//  cc2dTest
//
//  Created by Chang Shun-Kuei on 5/1/12.
//  Copyright (c) 2012 n/a. All rights reserved.
//
#import "cocos2d.h"
#import "MenuScene.h"

#import "BackgroundLayer.h"
#import "MainMenu.h"

@implementation MenuScene

MainMenu *mainMenu;
- (id)init
{
    if(self=[super init]) 
    {
    }
    return self;
}


+ (id)scene 
{
    
    CCScene *scene = [CCScene node];
    
    
    mainMenu = [[MainMenu alloc] initWithManager:self] ;

    [[[CCDirector sharedDirector] openGLView] addSubview:mainMenu]; 
    
    return scene;
}

- (void)dealloc 
{
    [mainMenu release];
    [super dealloc];
}

@end
