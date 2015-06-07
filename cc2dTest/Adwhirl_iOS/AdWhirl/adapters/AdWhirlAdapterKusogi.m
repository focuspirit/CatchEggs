//
//  AdWhirlAdapterKusogi.m
//  adWhirlSDK_iOS
//
//  Created by  on 11/10/18.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "AdWhirlAdapterKusogi.h"
#import "AdWhirlAdapterGoogleAdMobAds.h"
#import "AdWhirlAdNetworkConfig.h"
#import "AdWhirlView.h"
#import "AdWhirlLog.h"
#import "AdWhirlAdNetworkAdapter+Helpers.h"
#import "AdWhirlAdNetworkRegistry.h"

@implementation AdWhirlAdapterKusogi

+ (void)load {
    [[AdWhirlAdNetworkRegistry sharedRegistry] registerClass:self];
}

+ (AdWhirlAdNetworkType)networkType {
    NSLog(@"AdWhirlAdapterKusogi");
    return AdWhirlAdNetworkTypeKusogi;
}

- (void)getAd {
    
    ad = [[kuADController alloc] init];
	[ad setKuDelegate:self];										//設定KuDelegate
    
    
    self.adNetworkView = [[ad kuADId:networkConfig.pubId                                     //Kusogi提供的APP ID
                              adRect:CGRectMake(0, 0, 320, 48)                               //廣告的位置大小
                  yourRootController:[adWhirlDelegate viewControllerForPresentingModalView]  //開發者最底層的View
                 yourStatusBarHidden:NO] autorelease];                                       //yourStatusBarHidden 設定你的狀態列為隱藏或不隱藏
    
    [adWhirlView adapter:self didReceiveAdView:self.adNetworkView];

}

- (void) kuADStatus:(BOOL)status
{
    NSLog(@"kuADStatus");
    if(status) 
        NSLog(@"kuADStatus : YES");
    else
        NSLog(@"kuADStatus : NO");
}

- (void)stopBeingDelegate {
    if (self.adNetworkView != nil
        && [self.adNetworkView respondsToSelector:@selector(setDelegate:)]) {
        [self.adNetworkView performSelector:@selector(setDelegate:)
                                 withObject:nil];
    }
}

- (void)dealloc {
    [ad release];
	[super dealloc];
}

@end
