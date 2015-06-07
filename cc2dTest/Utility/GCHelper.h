//
//  GCHelper.h
//  CatchEggs
//
//  Created by Chang Shun-Kuei on 6/16/12.
//  Copyright (c) 2012 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SynthesizeSingleton.h"

#define kAuthenticationChanged @"AuthenticationChanged"


@interface GCHelper : NSObject
{
    BOOL gameCenterAvailable;
    BOOL userAuthenticated;
    BOOL uploadScore;
    NSString *playerID;
    NSString *playerAlias;
}
@property (assign, readonly) BOOL gameCenterAvailable;
@property (assign, readonly) BOOL userAuthenticated;
@property (assign) BOOL uploadScore;
@property (retain, readonly) NSString *playerID;
@property (retain, readonly) NSString *playerAlias;


+ (GCHelper *)sharedGCHelper;
- (void)authenticateLocalUser;
- (BOOL)reportScore:(NSUInteger)paramScore toLeaderboard:(NSString *)paramLeaderboard;

@end
