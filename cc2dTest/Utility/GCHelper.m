//
//  GCHelper.m
//  CatchEggs
//
//  Created by Chang Shun-Kuei on 6/16/12.
//  Copyright (c) 2012 n/a. All rights reserved.
//

#import "GCHelper.h"
#import <GameKit/GameKit.h>
#import "GKAchievementHandler.h"
#import "UIDevice+machine.h"
@implementation GCHelper
SYNTHESIZE_SINGLETON_FOR_CLASS(GCHelper);


@synthesize gameCenterAvailable;
@synthesize userAuthenticated;
@synthesize uploadScore;
@synthesize playerAlias;
@synthesize playerID;

- (id)init
{
    if ((self = [super init]))
    {
        gameCenterAvailable = [self isGameCenterAvailable];
        
        
        // NSLog(@"gameCenterAvailable:%d",gameCenterAvailable);
        
        if (gameCenterAvailable)
        {
            NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
            [nc addObserver:self
                   selector:@selector(authenticationChanged)
                       name:GKPlayerAuthenticationDidChangeNotificationName
                     object:nil];
        }
    }
    return self;
}

- (BOOL)isGameCenterAvailable
{
    // check for presence of GKLocalPlayer API
    Class gcClass = (NSClassFromString(@"GKLocalPlayer"));
    
    // check if the device is running iOS 4.1 or later
    NSString *reqSysVer = @"4.1";
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    BOOL osVersionSupported = ([currSysVer compare:reqSysVer
                                           options:NSNumericSearch] != NSOrderedAscending);
    
    return (gcClass && osVersionSupported);
}



- (void)authenticationChanged
{    
    
    if ([GKLocalPlayer localPlayer].isAuthenticated && !userAuthenticated)
    {
        // NSLog(@"Authentication changed: player authenticated.");
        // NSLog(@"Player ID = %@", [[GKLocalPlayer localPlayer] playerID]);
        // NSLog(@"Player Alias = %@", [[GKLocalPlayer localPlayer] alias]);
        
        playerID = [[GKLocalPlayer localPlayer] playerID];
        playerAlias = [[GKLocalPlayer localPlayer] alias];
        
        
        userAuthenticated = TRUE;
        uploadScore = YES;

    }
    else if (![GKLocalPlayer localPlayer].isAuthenticated && userAuthenticated)
    {
        // NSLog(@"Authentication changed: player not authenticated");
        [[GKAchievementHandler defaultHandler] notifyAchievementTitle:@"GameCenter" 
                                                           andMessage:@"Player not authenticated."];
        
        userAuthenticated = FALSE;
        uploadScore = NO;

    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kAuthenticationChanged object:nil];

    
}

#pragma mark User functions

- (void)authenticateLocalUser
{ 
    
    if (!gameCenterAvailable) return;
    
    NSLog(@"Authenticating local user...");
    if ([GKLocalPlayer localPlayer].authenticated == NO)
    {
        

        [[GKLocalPlayer localPlayer] authenticateWithCompletionHandler:^(NSError *error) {
            if (error == nil){
                NSLog(@"Successfully authenticated.");
            } else {
                
                if(![GKLocalPlayer localPlayer].isAuthenticated)
                {
                    NSLog(@"Failed to authenticate. Error = %@", error.localizedDescription);
                    
                    [[GKAchievementHandler defaultHandler] notifyAchievementTitle:@"GameCenter" 
                                                                       andMessage:error.localizedDescription];
                }
                 
                
            }
        }];
    }
    else
    {
        // NSLog(@"Already authenticated!");

        // NSLog(@"Player ID = %@", [[GKLocalPlayer localPlayer] playerID]);
        // NSLog(@"Player Alias = %@", [[GKLocalPlayer localPlayer] alias]);
        
        
        playerID = [[GKLocalPlayer localPlayer] playerID];
        playerAlias = [[GKLocalPlayer localPlayer] alias];

        
        uploadScore = YES;

    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kAuthenticationChanged object:nil];

}


- (BOOL)reportScore:(NSUInteger)paramScore toLeaderboard:(NSString *)paramLeaderboard
{
    if(!uploadScore) return NO;
    
    __block BOOL result = NO;
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    if ([localPlayer isAuthenticated] == NO){
        NSLog(@"You must authenticate the local player first.");
        return NO;
    }
    if ([paramLeaderboard length] == 0){
        NSLog(@"Leaderboard identifier is empty.");
        return NO;
    }
    GKScore *score = [[[GKScore alloc] initWithCategory:paramLeaderboard] autorelease];
    
    score.value = (int64_t)paramScore;
    NSLog(@"Attempting to report the score...PlayerID:%@",score.playerID);
    [score reportScoreWithCompletionHandler:^(NSError *error) {
        
        if (error == nil){
            NSLog(@"Succeeded.");
            result = YES;
        } else {
            NSLog(@"Failed to report the error. Error = %@", error);
            [[GKAchievementHandler defaultHandler] notifyAchievementTitle:@"GameCenter" 
                                                               andMessage:error.localizedDescription];
        }
    }];
    return result;
}
@end
