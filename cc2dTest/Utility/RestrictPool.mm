//
//  RestrictPool.m
//  CatchEggs
//
//  Created by Chang Shun-Kuei on 4/14/12.
//  Copyright (c) 2012 n/a. All rights reserved.
//

#import "RestrictPool.h"

@implementation RestrictPool
@synthesize poolCount, pool;

SYNTHESIZE_SINGLETON_FOR_CLASS(RestrictPool);

- (id)init
{
    
    if(self = [super init]) 
    {
        pool = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)initPoolWithClass:(NSString *)className poolSize:(int)maxSize initMethod:(NSString *)initMethod actionMethod:(NSString *)actionMethod
{
    maxPoolSize=maxSize;
    objClassName = className;
    objInitFunc = initMethod;
    objActionFunc = actionMethod;
    selInitFunc=NSSelectorFromString(objInitFunc);
    selActionFunc=NSSelectorFromString(objActionFunc);

    for (int i =0; i<maxSize; i++) 
    {
        //動態產生所指定物件
        [pool addObject:[[NSClassFromString(className) alloc] init]]; 
        
    }
    [self resetPool];
    
}

- (void)dealloc
{
    for (CCSprite *sprite in pool)
    {
        [sprite release];
    }
    [pool release];
    [super dealloc]; 
}


- (void)resetPool
{
            
    for (CCSprite *sprite in pool)
    {
        
        [sprite setVisible:NO];
        
    }
    poolCount=0;
    serialCounter=0;
}


- (id)getFreeSprite
{
    
    for (CCSprite *sprite in pool)
    {
        if ([sprite visible]==NO) 
        {
            return sprite;
        }
    }
    return nil;
    
}

- (int)refrashSprite:(CCSprite *)idSprite
{

    for (CCSprite *sprite in pool)
    {
        if([sprite isEqual:idSprite])
        {
            serialCounter+=1;
            poolCount++;
            return serialCounter;

        }
    }

    return -1;
}



- (BOOL)disappearSprite:(CCSprite *)eraseSprite
{
    for (CCSprite *sprite in pool)
    {
        if([sprite isEqual:eraseSprite])
        {
            [sprite setVisible:NO];
            
            poolCount--;

            
            return YES;
        }
    }
    return NO; 
}

@end
