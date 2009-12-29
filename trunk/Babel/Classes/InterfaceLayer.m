//
//  InterfaceLayer.m
//  Genoma
//
//  Created by Giovanni Amati on 24/11/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "InterfaceLayer.h"
#import "SharedData.h"

#define MOVE 20

enum {
	kTagBack = 10000,
};

@implementation InterfaceLayer

@synthesize menu, sel, num;

-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if ((self = [super init]))
	{
		CCSprite *backmenu = [CCSprite spriteWithFile:@"back.png"];
		[backmenu setOpacity:100];
		[backmenu setPosition:ccp(0, 117)];
		[backmenu setAnchorPoint:ccp(0, 1)];
		
		CCMenuItemImage *item1 = [CCMenuItemImage itemFromNormalImage:@"arrow2.png" selectedImage:@"arrow.png" target:self selector:@selector(upCallback:)];
		CCMenuItemImage *item2 = [CCMenuItemImage itemFromNormalImage:@"arrow2.png" selectedImage:@"arrow.png" target:self selector:@selector(downCallback:)];
		CCMenuItemImage *item3 = [CCMenuItemImage itemFromNormalImage:@"arrow2.png" selectedImage:@"arrow.png" target:self selector:@selector(leftCallback:)];
		CCMenuItemImage *item4 = [CCMenuItemImage itemFromNormalImage:@"arrow2.png" selectedImage:@"arrow.png" target:self selector:@selector(rightCallback:)];		
				
		[item1 setRotation:-90];
		[item2 setRotation:90];
		[item3 setRotation:-180];
		[item1 setPosition:ccp(402, 80)];
		[item2 setPosition:ccp(402, 30)];
		[item3 setPosition:ccp(357, 55)];
		[item4 setPosition:ccp(447, 55)];
		
		CCMenu *controller = [CCMenu menuWithItems:item1, item2, item3, item4, nil];
		[controller setOpacity:100];
		[controller setPosition:CGPointZero];
		
		[self addChild:backmenu z:0  tag:kTagBack];
		[self addChild:controller z:0];
		
		[self initMenu:@"Main"];
	}
	
	return self;
}

-(void) initMenu:(NSString *)name
{
	CCSprite *backmenu = (CCSprite *)[self getChildByTag:kTagBack];
	
	for (int i = 0; i < num; i++) // clean
		[self removeChildByTag:i cleanup:TRUE];
	
	sel = 0;
	num = 0;
	
	NSMutableArray *menuitems = [[SharedData Initialize] getMenu:name];
	
	if (NULL == menuitems) // se null e' una azione
	{
		menu = NULL; // liberare?
		//[backmenu setVisible:NO];
		[backmenu runAction:[CCMoveTo actionWithDuration:0.1 position:ccp(backmenu.position.x, 0)]];
		// fare azione
		[[SharedData Initialize] nextTurn];
		
		CCLOG(@"------------> %s %s", [name UTF8String], [menu UTF8String]);
		return;
	}
	
	menu = name;
	//[backmenu setVisible:YES];
	[backmenu runAction:[CCMoveTo actionWithDuration:0.1 position:ccp(backmenu.position.x, 117)]];
	NSString *aFont = @"Lucon1";
	
	int y = 50;
	for (NSString *str in menuitems)
	{
		CCLabel *lb = [CCLabel labelWithString:str dimensions:CGSizeMake(120, 28) alignment:UITextAlignmentLeft fontName:aFont fontSize:14];
		lb.position = ccp(72, y);
		y -= MOVE;
		[self addChild:lb z:1 tag:num];
		[self configMenu:num move:0];
		num += 1;
	}
}

-(void) configMenu:(int)i move:(int)m
{
	CCLabel *lb = (CCLabel *)[self getChildByTag:i];
	
	[lb runAction:[CCMoveTo actionWithDuration:0.1 position:ccp(lb.position.x, lb.position.y + m)]];
	//it.position = ccp(it.position.x, it.position.y + m);
	
	if (sel == i)
		[lb setOpacity:200];
	else if ((sel - 1 == i) || (sel + 1 == i))
		[lb setOpacity:100];
	else if ((sel - 2 == i) || (sel + 2 == i))
		[lb setOpacity:50];
	else
		[lb setOpacity:0];
}

-(void) upCallback:(id)sender
{
	if (sel > 0)
	{
		sel -= 1;
		for (int i = 0; i < num; i++)
			[self configMenu:i move:-MOVE];
	}
}

-(void) downCallback:(id)sender
{
	if (sel < num - 1) // occhio qua!!!!!!!!! - 1
	{
		sel += 1;
		for (int i = 0; i < num; i++)
			[self configMenu:i move:MOVE];
	}
}

-(void) leftCallback:(id)sender
{
	[self initMenu:@"Main"];
}

-(void) rightCallback:(id)sender
{
	NSMutableArray *menuitems = [[SharedData Initialize] getMenu:menu];
	NSString *name = [menuitems objectAtIndex:sel];
	
	[self initMenu:name];
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