//
//  UIDevice+machine.h
//  CatchEggs
//
//  Created by Chang Shun-Kuei on 6/16/12.
//  Copyright (c) 2012 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kNetworkReachabilityChanged @"NetworkReachabilityChanged"


@interface UIDevice (machine)



- (NSString *)machine;
+ (void)watchNetworkReachability;                 
+ (BOOL)networkReachability;

@end
