//
//  PlayerData.m
//  Babel
//
//  Created by Giovanni Amati on 28/12/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PlayerData.h"

@implementation PlayerData

@synthesize name;

-(id) initWithName:(NSString *)name_id
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if ((self = [super init]))
	{
		self.name = name_id;
	}
	
	return self;
}

-(NSMutableArray *) getMagicMenu
{
	// i dati li deve leggere dalla sorgente
	NSMutableArray *a = [NSMutableArray array];
	[a addObject:@"Fire     25"];
	[a addObject:@"Wind     25"];
	[a addObject:@"Water    25"];
	if (@"Vito" == self.name)
	{
		[a addObject:@"Blizard  25"];
		[a addObject:@"Earth    25"];
	}
	return a;
}

// on "dealloc" you need to release all your retained objects
-(void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	NSLog(@"------------------- RELEASE PLAYER ----------------------");
	[super dealloc];
}

@end