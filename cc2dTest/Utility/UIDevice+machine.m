//
//  UIDevice+machine.m
//  CatchEggs
//
//  Created by Chang Shun-Kuei on 6/16/12.
//  Copyright (c) 2012 n/a. All rights reserved.
//

#include "sys/types.h"
#include "sys/sysctl.h"
#import <SystemConfiguration/SCNetworkReachability.h>
#import <netinet/in.h>
#import <UIKit/UIKit.h>
#import "Reachability.h"
#import "UIDevice+machine.h"




@implementation UIDevice (machine)
Reachability* internetReachable;
Reachability* hostReachable;

BOOL netStatus;

- (NSString*)machine
{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *answer = malloc(size);
    sysctlbyname("hw.machine", answer, &size, NULL, 0);
    NSString *results = [NSString stringWithCString:answer encoding: NSUTF8StringEncoding];
    free(answer);
    return results;
}

+(BOOL)isNetworkReachable{
    // Create zero addy
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags)
    {
        return NO;
    }
    
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    
    netStatus = (isReachable && !needsConnection) ? YES : NO;
    
    return netStatus;



} 
                      
                      
+ (void)watchNetworkReachability                   
{
    
    
    // check for internet connection
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    

    //有無訊號
    internetReachable = [[Reachability reachabilityForInternetConnection] retain];
    [internetReachable startNotifier];
    
    //確認是否真的連出去
    hostReachable = [[Reachability reachabilityWithHostName: @"www.apple.com"] retain];
    [hostReachable startNotifier];

    
    NetworkStatus internetStatus = [hostReachable currentReachabilityStatus];
    NSLog(@"watchNetworkReachability:%d",internetStatus);

    if (internetStatus == NotReachable) 
    {
		netStatus = NO;
	} else {
		netStatus = YES;
	}

}

+ (void)reachabilityChanged:(NSNotification *)notice 
{
    
    NetworkStatus internetStatus = [hostReachable currentReachabilityStatus];
    
    NSLog(@"reachabilityChanged:%d",internetStatus);
    
    if (internetStatus == NotReachable) 
    {
		netStatus = NO;
	} else {
		netStatus = YES;
	}

    [[NSNotificationCenter defaultCenter] postNotificationName:kNetworkReachabilityChanged object:nil];

}

+ (BOOL)networkReachability
{
    return netStatus;
}


@end
