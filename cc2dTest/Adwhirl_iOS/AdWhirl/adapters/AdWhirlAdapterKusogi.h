//
//  AdWhirlAdapterKusogi.h
//  adWhirlSDK_iOS
//
//  Created by Kusogi on 11/10/18.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdWhirlAdNetworkAdapter.h"
#import "bannerViewDelegate.h"
#import "kuADController.h"


@interface AdWhirlAdapterKusogi : AdWhirlAdNetworkAdapter <kuADDelegate> {
    kuADController *ad;
}

@end
