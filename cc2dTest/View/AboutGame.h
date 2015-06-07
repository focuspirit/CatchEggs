//
//  AboutGame.h
//  CatchEggs
//
//  Created by Chang Shun-Kuei on 3/19/12.
//  Copyright (c) 2012 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalVar.h"

@interface AboutGame : UIImageView <UITextFieldDelegate>
{
    id RootManager;
    UITextField *secondsField;
    UITextField *scoredsField;
}

- (id)initWithManager:(id)manager;

@end
