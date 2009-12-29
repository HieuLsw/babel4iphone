//
//  SharedData.m
//  Genoma
//
//  Created by Giovanni Amati on 08/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SharedData.h"
#import "PlayerData.h"

@implementation SharedData

@synthesize mainMenu, playerList, playerSel;

-(void) dealloc
{
	NSLog(@"------------------- RELEASE SINGETON DATA ----------------------");
	[mainMenu release];
	[playerList release];
	[super dealloc];
}

-(void) initGame
{
	self.playerSel = 0;
	
	self.mainMenu = [NSMutableArray array];
	[self.mainMenu addObject:@"Attack"];
	[self.mainMenu addObject:@"Magics"];
	[self.mainMenu addObject:@"Invocations"];
	[self.mainMenu addObject:@"Items"];
	[self.mainMenu addObject:@"Team"];
	[self.mainMenu addObject:@"Settings"];
	
	// deve essere fatta dalla sorgente
	self.playerList = [NSMutableArray array];
	[self.playerList addObject:[[[PlayerData alloc] initWithName:@"Vito"] autorelease]];
	[self.playerList addObject:[[[PlayerData alloc] initWithName:@"Gino"] autorelease]];
}

-(NSMutableArray *) getMenu:(NSString *)name
{
	if (@"Main" == name)
		return self.mainMenu;
	else if (@"Magics" == name)
		return [[self.playerList objectAtIndex:self.playerSel] getMagicMenu];
	else
		return NULL;
}

-(void) nextTurn
{
	self.playerSel = (self.playerSel + 1) % [self.playerList count];
}

/////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////// Singleton ///////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////

static SharedData *sharedMyData = nil;

+(SharedData *) Initialize
{
    @synchronized(self)
	{
        if (sharedMyData == nil)
		{
            [[self alloc] init];
        }
    }
	
    return sharedMyData;
}

+(id) allocWithZone:(NSZone *)zone
{
    @synchronized(self)
	{
        if (sharedMyData == nil)
		{
            sharedMyData = [super allocWithZone:zone];
            return sharedMyData;
        }
    }
	
    return nil;
}

-(id) copyWithZone:(NSZone *)zone
{	
    return self;
}

-(id) retain
{
    return self;
}

-(unsigned) retainCount
{
    return UINT_MAX;
}

-(void) release
{
	[super release];
}

-(id) autorelease
{
	return self;
}

@end