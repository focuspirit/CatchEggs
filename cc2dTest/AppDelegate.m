//
//  AppDelegate.m
//  cc2dTest
//
//  Created by Chang Shun-Kuei on 4/11/12.
//  Copyright n/a 2012. All rights reserved.
//


#import "cocos2d.h"
#import <GameKit/GameKit.h>
#import "UIDevice+machine.h"

#import "AppDelegate.h"
#import "GameConfig.h"
#import "FlurryAnalytics.h"
#import "LocalyticsSession.h"
#import "GANTracker.h"
#import "Appirater.h"

#import "SimpleAudioEngine.h"
#import "RootViewController.h"
#import "AdRootViewController.h"
#import "GameScene.h"
#import "GameManager.h"
#import "MainMenu.h"
#import "GCHelper.h"

#import <ifaddrs.h>
#import <arpa/inet.h>
#import "IPAddress.h"

@implementation AppDelegate

@synthesize window, viewController, isMute;

// Dispatch period in seconds
static const NSInteger kGANDispatchPeriodSec = 10;


- (void) removeStartupFlicker
{
    
#if GAME_AUTOROTATION == kGameAutorotationUIViewController

	CC_ENABLE_DEFAULT_GL_STATES();
	CCDirector *director = [CCDirector sharedDirector];
	//CGSize size = [director winSize];
	//CCSprite *sprite = [CCSprite spriteWithFile:@"Default.png"];
	//sprite.position = ccp(size.width/2, size.height/2);
	//sprite.rotation = -90;
	//[sprite visit];
	[[director openGLView] swapBuffers];
	CC_ENABLE_DEFAULT_GL_STATES();
	
#endif // GAME_AUTOROTATION == kGameAutorotationUIViewController	
}
- (void) applicationDidFinishLaunching:(UIApplication*)application
{ 
    isMute = NO;
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"theme.m4a" loop:YES];
        
    });
    


	// Init the window
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    //if([self gameCenterSupported]) [self authenticateLocalPlayerAndGetHerInfo];
    
    [UIDevice watchNetworkReachability];
    
        
    
    gameManager = [GameManager sharedGameManager];
    
	// Try to use CADisplayLink director
	// if it fails (SDK < 3.1) use the default director
	if( ! [CCDirector setDirectorType:kCCDirectorTypeDisplayLink] )
		[CCDirector setDirectorType:kCCDirectorTypeDefault];
    [[CCDirector sharedDirector] setProjection:CCDirectorProjection2D];

	
	CCDirector *director = [CCDirector sharedDirector];
	// Init the View Controller
	AdRootViewController *controller = [[AdRootViewController alloc] initWithNibName:nil bundle:nil];	
    controller.wantsFullScreenLayout = YES;
	
    //Assign the viewController
    self.viewController = controller;
    [controller release];
    
	//
	// Create the EAGLView manually
	//  1. Create a RGB565 format. Alternative: RGBA8
	//	2. depth format of 0 bit. Use 16 or 24 bit for 3d effects, like CCPageTurnTransition
	//
	//
	EAGLView *glView = [EAGLView viewWithFrame:[window bounds]
								   pixelFormat:kEAGLColorFormatRGB565	// kEAGLColorFormatRGBA8
								   depthFormat:0						// GL_DEPTH_COMPONENT16_OES
						];
	
	// attach the openglView to the director
	[director setOpenGLView:glView];
	
//	// Enables High Res mode (Retina Display) on iPhone 4 and maintains low res on all other devices
	if( ! [director enableRetinaDisplay:YES] )
		CCLOG(@"Retina Display Not supported");
	
	//
	// VERY IMPORTANT:
	// If the rotation is going to be controlled by a UIViewController
	// then the device orientation should be "Portrait".
	//
	// IMPORTANT:
	// By default, this template only supports Landscape orientations.
	// Edit the RootViewController.m file to edit the supported orientations.
	//
#if GAME_AUTOROTATION == kGameAutorotationUIViewController
	[director setDeviceOrientation:kCCDeviceOrientationPortrait];
	//[director setDeviceOrientation:kCCDeviceOrientationLandscapeLeft];
#else
	[director setDeviceOrientation:kCCDeviceOrientationLandscapeLeft];
#endif
	
	[director setAnimationInterval:1.0/60];	
	
	// make the OpenGLView a child of the view controller
	[viewController setView:glView];
	
	// make the View Controller a child of the main window
	[window addSubview: viewController.view];
	
	[window makeKeyAndVisible];
	
	// Default texture format for PNG/BMP/TIFF/JPEG/GIF images
	// It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
	// You can change anytime.
	//[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA4444];
    [CCTexture2D PVRImagesHavePremultipliedAlpha:YES];

	
	// Removes the startup flicker
	[self removeStartupFlicker];
	
	// Run the intro Scene
	//[[CCDirector sharedDirector] runWithScene: [HelloWorldLayer scene]];
    

    eggPool = [RestrictPool sharedRestrictPool];
    [eggPool initPoolWithClass:@"Egg" poolSize:MAX_POOL_EGGS initMethod:@"startWithDictArguments:" actionMethod:@"startFalling"];
    
    if([UIFont fontWithName:@"Chalkduster" size:16])
    {
        CCLOG(@"Chalkduster");
        displayFont = @"Chalkduster";
        displayFontSize = 16;
    }
    else {
        CCLOG(@"ChalkboardSE-Regular");
        displayFont = @"ChalkboardSE-Regular";
        displayFontSize = 18;
    }
    
    [[GCHelper sharedGCHelper] authenticateLocalUser];


    [Appirater appLaunched:YES];

    [gameManager runSceneWithID:kMainMenuScene];
    
     
     
}

- (void)doStateChange:(Class) state
{


}

- (void)applicationWillResignActive:(UIApplication *)application {
	if(!isPause)    [[CCDirector sharedDirector] pause];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	if(!isPause)    [[CCDirector sharedDirector] resume];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
	[[CCDirector sharedDirector] purgeCachedData];
}

-(void) applicationDidEnterBackground:(UIApplication*)application {
	[[CCDirector sharedDirector] stopAnimation];
    [[LocalyticsSession sharedLocalyticsSession] close];
    [[LocalyticsSession sharedLocalyticsSession] upload];
}

-(void) applicationWillEnterForeground:(UIApplication*)application {
	[[CCDirector sharedDirector] startAnimation];
    [[LocalyticsSession sharedLocalyticsSession] resume];
    [[LocalyticsSession sharedLocalyticsSession] upload];
    [Appirater appEnteredForeground:YES];
}

- (void)applicationWillTerminate:(UIApplication *)application {
	CCDirector *director = [CCDirector sharedDirector];
	
	[[director openGLView] removeFromSuperview];
	
	[viewController release];
	
	[window release];
	
	[director end];	
    
    [[LocalyticsSession sharedLocalyticsSession] close];
    [[LocalyticsSession sharedLocalyticsSession] upload];
}

- (void)applicationSignificantTimeChange:(UIApplication *)application {
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}

- (void)dealloc {
	[[CCDirector sharedDirector] end];
    [[GANTracker sharedTracker] stopTracker];
	[window release];
	[super dealloc];
}


@end
