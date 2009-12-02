//
//  MenuLayer.m
//  Genoma
//
//  Created by Giovanni Amati on 24/11/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MenuLayer.h"

@implementation MenuLayer

-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if ((self = [super init]))
	{
		CCMenuItemImage *item1 = [CCMenuItemImage itemFromNormalImage:@"Exit.png" selectedImage:@"Exit.png" target:self selector:@selector(act1Callback:)];
		CCMenuItemImage *item2 = [CCMenuItemImage itemFromNormalImage:@"Exit.png" selectedImage:@"Exit.png" target:self selector:@selector(act2Callback:)];
		
		CCMenu *menu = [CCMenu menuWithItems:item1, item2, nil];
		
		[menu setPosition:CGPointZero];
		[item1 setPosition:ccp(30, 30)];
		[item2 setPosition:ccp(75, 30)];
		
		[self addChild:menu z:0];
	}
	
	return self;
}

-(void) act1Callback:(id)sender
{
	CCLOG(@"-----------> ACT1");
}

-(void) act2Callback:(id)sender
{
	CCLOG(@"-----------> ACT2");
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}

@end