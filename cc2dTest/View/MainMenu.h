//
//  MainMenu.h
//  CatchEggs
//
//  Created by Chang Shun-Kuei on 3/16/12.
//  Copyright (c) 2012 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h> 
//#import "AboutGame.h"
//#import "ScoreBoard.h"


@interface MainMenu : UIImageView
{
    //UIImage *theme_background;
    id RootManager;
}
- (id)initWithManager:(id)manager;

@end
