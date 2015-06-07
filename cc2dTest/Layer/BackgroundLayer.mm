//
//  BackgroundLayer.m
//  cc2dTest
//
//  Created by Chang Shun-Kuei on 4/12/12.
//  Copyright (c) 2012 n/a. All rights reserved.
//

#import "BackgroundLayer.h"

@implementation BackgroundLayer



// on "init" you need to initialize your instance
- (id)init
{
	if( (self=[super init])) {

 
	}
	return self;
}

- (void)wallpaperFromImage:(NSString *)filename
{
    CCSprite *backgroundImage;
    backgroundImage = [CCSprite spriteWithFile:filename];
    
    //[backgroundImage setScale:0.5];
    
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    
    [backgroundImage setPosition:CGPointMake(screenSize.width/2, screenSize.height/2)];
    
    [self addChild:backgroundImage z:0 tag:0];
}


- (void)dealloc 
{  
    [super dealloc];  
}  

@end
