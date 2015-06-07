//
//  ScoreBoard.h
//  CatchEggs
//
//  Created by Chang Shun-Kuei on 3/19/12.
//  Copyright (c) 2012 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalVar.h"

@interface ScoreBoard : UIImageView
{
    id RootManager;

}

- (id)initWithManager:(id)manager;

@end
