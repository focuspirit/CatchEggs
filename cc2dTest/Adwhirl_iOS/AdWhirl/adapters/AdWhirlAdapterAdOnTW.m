//
//  AdWhirlAdapterAdOnTW.m
//  iphone-sdk-adwhirl
//
//  Created by Shark on 2010/10/14.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AdWhirlAdapterAdOnTW.h"
#import "AdWhirlAdNetworkConfig.h"
#import "AdWhirlView.h"
#import "AdWhirlLog.h"
//#import "AdWhirlAdNetworkAdapter+Helpers.h"
#import "AdWhirlAdNetworkRegistry.h"

@implementation AdWhirlAdapterAdOnTW

+ (AdWhirlAdNetworkType)networkType {
	NSLog(@"AdWhirlAdNetworkTypeAdOnTW");
	return AdWhirlAdNetworkTypeAdOnTW;
}

+ (void)load {
	[[AdWhirlAdNetworkRegistry sharedRegistry] registerClass:self];
}

- (void)getAd {
	
	
	adOnView = [[VponAdOnView alloc] initWithFrame:CGRectMake(0, 0, 320, 48)];
	[adOnView requestAdWithSize:ADON_SIZE_320x48 setAdOnDelegate:self];
	
	self.adNetworkView = adOnView;
	
	
}

-(void) onRecevieAd:(VponAdOnView*) view{
	NSLog(@"AdOn onRecevieAd");
	[adWhirlView adapter:self didReceiveAdView:adOnView];
}

-(void) onFailedToRecevieAd:(VponAdOnView*) view{
	NSLog(@"AdOn onFailedToRecevieAd");
	[adWhirlView adapter:self didFailAd:nil];
}

- (NSString *) adonLicenseKey{
	
	return networkConfig.pubId;
}

- (Boolean) autoRefreshAdonAd{
	
	return NO;
}

- (double) locationLatitude{
	if ([adWhirlDelegate respondsToSelector:@selector(locationInfo)]) {
		return [adWhirlDelegate locationInfo].coordinate.latitude;
	}
	return 0;
}

- (double) locationLongtitude{
	if ([adWhirlDelegate respondsToSelector:@selector(locationInfo)]) {
		return [adWhirlDelegate locationInfo].coordinate.longitude;
	}
	return 0;
}

- (Platform) getPlatform {	
	return TW;
}

- (void)stopBeingDelegate {
	[adOnView removeDelegate];
//	adOnView.adOnDelegate = nil;
	// no way to set inMobiView's delegate to nil
}

- (void)dealloc {
	[super dealloc];
}


@end
