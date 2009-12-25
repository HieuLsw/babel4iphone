//
//  InterfaceLayer.m
//  Genoma
//
//  Created by Giovanni Amati on 24/11/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "InterfaceLayer.h"

#define MOVE 20

@implementation InterfaceLayer

@synthesize sel, num;

-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if ((self = [super init]))
	{
		CCMenuItemImage *item1 = [CCMenuItemImage itemFromNormalImage:@"arrow2.png" selectedImage:@"arrow.png" target:self selector:@selector(upCallback:)];
		CCMenuItemImage *item2 = [CCMenuItemImage itemFromNormalImage:@"arrow2.png" selectedImage:@"arrow.png" target:self selector:@selector(downCallback:)];
		CCMenuItemImage *item3 = [CCMenuItemImage itemFromNormalImage:@"arrow2.png" selectedImage:@"arrow.png" target:self selector:@selector(leftCallback:)];
		CCMenuItemImage *item4 = [CCMenuItemImage itemFromNormalImage:@"arrow2.png" selectedImage:@"arrow.png" target:self selector:@selector(rightCallback:)];
		
		CCMenu *menu = [CCMenu menuWithItems:item1, item2, item3, item4, nil];
		[self addChild:menu z:0];
		
		[menu setPosition:CGPointZero];
		
		[item1 setOpacity:50];
		[item1 setRotation:-90];
		[item2 setOpacity:50];
		[item2 setRotation:90];
		[item3 setOpacity:50];
		[item3 setRotation:-180];
		[item4 setOpacity:50];
		
		[item1 setPosition:ccp(402, 80)];
		[item2 setPosition:ccp(402, 30)];
		[item3 setPosition:ccp(357, 55)];
		[item4 setPosition:ccp(447, 55)];
		
		// sara' dinamico
		NSArray *labels1 = [NSArray arrayWithObjects:@"a", @"ab", @"abc", @"Items", @"Team", @"Invocations", @"Magics", @"Attack", nil];
		//NSArray *labels2 = [NSArray arrayWithObjects:@"Items", @"Team", @"Invocations", @"Magics", @"Attack", nil];
		
		[self initMenu:labels1];
		//[self initMenu:labels2];
	}
	
	return self;
}

-(void) initMenu:(NSArray *)labels
{
	for (int i = 0; i < num; i++) // clean
		[self removeChildByTag:i cleanup:TRUE];
	
	NSString *aFont = @"Schwarzwald Regular";
	sel = 2;
	num = 0;
	
	int y = 18;
	for (NSString *myStr in labels)
	{
		CCLabel *it = [CCLabel labelWithString:myStr fontName:aFont fontSize:20];
		it.position = ccp(70, y);
		y += MOVE;
		[self addChild:it z:0 tag:num];
		[self configMenu:num move:0];
		num += 1;
	}
}

-(void) configMenu:(int)i move:(int)m
{
	CCLabel *it = (CCLabel *)[self getChildByTag:i];
	if (sel == i)
		[it setOpacity:200];
	else if ((sel - 1 == i) || (sel + 1 == i))
		[it setOpacity:100];
	else if ((sel - 2 == i) || (sel + 2 == i))
		[it setOpacity:50];
	else
		[it setOpacity:0];
	it.position = ccp(it.position.x, it.position.y + m);
}

-(void) upCallback:(id)sender
{
	if (sel > 0)
	{
		sel -= 1;
		for (int i = 0; i < num; i++)
			[self configMenu:i move:MOVE];
	}
}

-(void) downCallback:(id)sender
{
	if (sel < num - 1) // occhio qua!!!!!!!!! - 1
	{
		sel += 1;
		for (int i = 0; i < num; i++)
			[self configMenu:i move:-MOVE];
	}
}

-(void) leftCallback:(id)sender
{
	CCLOG(@"-----------> %d", sel);
}

-(void) rightCallback:(id)sender
{
	CCLOG(@"-----------> %d", sel);
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