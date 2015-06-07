//
//  PauseLayer.m
//  Pause
//
//  Created by Pablo Ruiz on 06/06/11.
//  Copyright 2011 PlaySnack. All rights reserved.
//

#import "PauseLayer.h"

@implementation PauseLayer

@synthesize delegate;

+ (id) layerWithColor:(ccColor4B)color delegate:(id)_delegate
{
	return [[[self alloc] initWithColor:color delegate:_delegate] autorelease];
}

- (id) initWithColor:(ccColor4B)c delegate:(id)_delegate {
    self = [super initWithColor:c];
    if (self != nil) {
        
        
		delegate = _delegate;
		[self pauseDelegate];
        

        
    }
    return self;
}

-(void)pauseDelegate
{
	if([delegate respondsToSelector:@selector(pauseLayerDidPause)])
		[delegate pauseLayerDidPause];
	[delegate onExit];
	[delegate.parent addChild:self z:10];
}

-(void)doResume: (id)sender
{
	[delegate onEnter];
	if([delegate respondsToSelector:@selector(pauseLayerDidUnpause)])
		[delegate pauseLayerDidUnpause];
	[self.parent removeChild:self cleanup:YES];
}

-(void)dealloc
{
	[super dealloc];
}

@end

