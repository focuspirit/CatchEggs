//
//  AppDelegate.h
//  cc2dTest
//
//  Created by Chang Shun-Kuei on 4/11/12.
//  Copyright n/a 2012. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GlobalVar.h"
#define UIAppDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> 
{
	UIWindow			*window;
	//RootViewController	*viewController;
	AdRootViewController	*viewController;
    BOOL    isMute;

}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) AdRootViewController *viewController;
@property (assign) BOOL isMute;


- (BOOL)gameCenterSupported;
- (void)authenticateLocalPlayer;


@end
