//
//  RestrictPool.h
//  CatchEggs
//
//  Created by Chang Shun-Kuei on 4/14/12.
//  Copyright (c) 2012 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SynthesizeSingleton.h"
//#import "GlobalVar.h"
#import "cocos2d.h"
#import "CCSprite.h"
//#import "Box2D.h"

//#define PTM_RATIO 32.0
//extern b2World         *_world;

@interface RestrictPool : NSObject
{
    NSMutableArray *pool;
    int poolCount;
    int serialCounter;    
    int maxPoolSize;
    
    NSString *objClassName;
    NSString *objInitFunc;
    NSString *objActionFunc;
    SEL     selInitFunc;
    SEL     selActionFunc;
}
@property (readonly) int poolCount;
@property (readonly) NSMutableArray *pool;

+ (RestrictPool *)sharedRestrictPool;

//- (void)initPoolWithClass:(NSString *)className poolSize:(int)maxSize;
- (void)initPoolWithClass:(NSString *)className poolSize:(int)maxSize initMethod:(NSString *)initMethod actionMethod:(NSString *)actionMethod;

//- (BOOL)setNewSpriteByMethod:(NSString *)initMethod dictArguments:(NSDictionary *)dict;
//- (BOOL)setNewSpriteWithDictArguments:(NSMutableDictionary *)dict;

- (BOOL)disappearSprite:(CCSprite *)eraseSprite;
- (void)resetPool;

//- (void)addBoxBodyForSprite:(CCSprite *)sprite;
//- (void)removeBoxBodyForSprite:(CCSprite *)sprite;
- (id)getFreeSprite;
//- (BOOL)refrashSprite:(id)idSprite actionMethod:(NSString *)actionMethod;
- (int)refrashSprite:(CCSprite *)idSprite;

@end
