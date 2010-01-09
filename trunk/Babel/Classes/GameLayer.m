//
//  GameLayer.m
//  Genoma
//
//  Created by Giovanni Amati on 08/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "GameLayer.h"
#import "SharedData.h"

@implementation GameLayer

-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if ((self = [super init]))
	{
		CCSprite *sprite = [CCSprite spriteWithFile:@"Default2.png"];
		sprite.anchorPoint = CGPointZero;
		[self addChild:sprite z:0];
	}
	
	return self;
}

-(void) goAction
{
	CCLOG(@"----> graphic animation");
}

// on "dealloc" you need to release all your retained objects
-(void) dealloc
{	
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}

@end