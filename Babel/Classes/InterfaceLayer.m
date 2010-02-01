//
//  InterfaceLayer.m
//  Genoma
//
//  Created by Giovanni Amati on 24/11/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "InterfaceLayer.h"
#import "SharedData.h"

#define SHIFT 10000 // shifta i tag degli item dei menu da 10000 in poi
#define MOVE 20

@implementation InterfaceLayer

-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if ((self = [super init]))
	{
		active = NO;
		
		CCSprite *backmenu = [CCSprite spriteWithFile:@"back.png"];
		[backmenu setOpacity:100];
		[backmenu setPosition:CGPointZero];
		[backmenu setAnchorPoint:ccp(0, 1)];
		
		CCMenuItemImage *a1 = [CCMenuItemImage itemFromNormalImage:@"arrow2.png" selectedImage:@"arrow.png" target:self selector:@selector(upCallback:)];
		CCMenuItemImage *a2 = [CCMenuItemImage itemFromNormalImage:@"arrow2.png" selectedImage:@"arrow.png" target:self selector:@selector(downCallback:)];
		CCMenuItemImage *a3 = [CCMenuItemImage itemFromNormalImage:@"arrow2.png" selectedImage:@"arrow.png" target:self selector:@selector(leftCallback:)];
		CCMenuItemImage *a4 = [CCMenuItemImage itemFromNormalImage:@"arrow2.png" selectedImage:@"arrow.png" target:self selector:@selector(rightCallback:)];		
				
		[a1 setRotation:-90];
		[a2 setRotation:90];
		[a3 setRotation:-180];
		
		[a1 setPosition:ccp(402, 80)];
		[a2 setPosition:ccp(402, 30)];
		[a3 setPosition:ccp(357, 55)];
		[a4 setPosition:ccp(447, 55)];
		
		CCMenu *controller = [CCMenu menuWithItems:a1, a2, a3, a4, nil];
		[controller setOpacity:100];
		[controller setPosition:CGPointZero];
		
		CGSize s = [[CCDirector sharedDirector] winSize];
		CCLabel *lturn = [CCLabel labelWithString:@"" dimensions:CGSizeMake(s.width, 44) alignment:UITextAlignmentCenter fontName:@"sr" fontSize:34];
		[lturn setPosition:ccp(s.width/2, s.height/2)];
		[lturn setOpacity:0];
		
		[self addChild:backmenu z:0  tag:0];
		[self addChild:controller z:0 tag:2];
		[self addChild:lturn z:0 tag:1];
	}
	
	return self;
}

-(void) initMenu:(NSArray *)menuitems
{	
	CCSprite *backmenu = (CCSprite *)[self getChildByTag:0];
	[backmenu runAction:[CCMoveTo actionWithDuration:0.1 position:ccp(backmenu.position.x, 117)]];
	
	int y = 50;
	for (NSString *item in menuitems)
	{
		CCLabel *lb = [CCLabel labelWithString:item dimensions:CGSizeMake(120, 28) alignment:UITextAlignmentLeft fontName:@"Lucon1" fontSize:14];
		lb.position = ccp(72, y);
		y -= MOVE;
		[self addChild:lb z:1 tag:num + SHIFT];
		[self configItem:num + SHIFT move:0];
		num += 1;
	}
	
	active = YES;
}

-(void) closeMenu
{
	active = NO;
	
	for (int i = 0 + SHIFT; i < num + SHIFT; i++) // clean
		[self removeChildByTag:i cleanup:TRUE];
	sel = 0;
	num = 0;
	
	CCSprite *backmenu = (CCSprite *)[self getChildByTag:0];
	[backmenu runAction:[CCMoveTo actionWithDuration:0.1 position:ccp(backmenu.position.x, 0)]];
}

-(void) configItem:(int)i move:(int)m
{
	CCLabel *lb = (CCLabel *)[self getChildByTag:i];
	[lb runAction:[CCMoveTo actionWithDuration:0.1 position:ccp(lb.position.x, lb.position.y + m)]];
	
	if (sel == i - SHIFT)
		[lb setOpacity:200];
	else if ((sel - 1 == i - SHIFT) || (sel + 1 == i - SHIFT))
		[lb setOpacity:100];
	else if ((sel - 2 == i - SHIFT) || (sel + 2 == i - SHIFT))
		[lb setOpacity:50];
	else
		[lb setOpacity:0];
}

-(void) setTurn:(NSString *)name
{
	CCLabel *lb = (CCLabel *)[self getChildByTag:1];
	[lb setString:[name stringByAppendingString:@" is ready!!!"]];
	[lb runAction:[CCSequence actions:[CCFadeIn actionWithDuration:1.0], [CCFadeOut actionWithDuration:1.0], nil]];
}

-(void) upCallback:(id)sender
{
	if (active)
	{
		if (sel > 0)
		{
			sel -= 1;
			for (int i = 0 + SHIFT; i < num + SHIFT; i++)
				[self configItem:i move:-MOVE];
		}
		CCLOG(@"Button up");
	}
}

-(void) downCallback:(id)sender
{
	if (active)
	{
		if (sel < num - 1) // occhio qua!!!!!!!!! - 1
		{
			sel += 1;
			for (int i = 0 + SHIFT; i < num + SHIFT; i++)
				[self configItem:i move:MOVE];
		}
		CCLOG(@"Button down");
	}
}

-(void) leftCallback:(id)sender
{
	if (active)
	{
		//[self initMenu:@"Main"]; // sempre a 2 livelli main e un altro
		CCLOG(@"Button left");
	}
}

-(void) rightCallback:(id)sender
{
	if (active)
	{
		//NSMutableArray *menuitems = [[SharedData Initialize] getMenu:menu];
		//NSString *name = [menuitems objectAtIndex:sel];
		//[self closeMenu];
		CCLOG(@"Button right");
	}
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