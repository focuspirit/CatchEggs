//
//  AdWhirlAdapterAdOnTW.h
//  iphone-sdk-adwhirl
//
//  Created by Shark on 2010/10/14.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AdWhirlAdNetworkAdapter.h"
#import "AdOnDelegate.h"
#import "VponAdOnView.h"
#import "AdOnPlatform.h"
#import <CoreLocation/CLLocationManagerDelegate.h> 

@interface AdWhirlAdapterAdOnTW: AdWhirlAdNetworkAdapter<VponAdOnDelegate>{
	VponAdOnView *adOnView;
}

+ (AdWhirlAdNetworkType) networkType;

@end
