//
//  SharedData.m
//  Genoma
//
//  Created by Giovanni Amati on 08/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SharedData.h"
#import "CCDirector.h"
#import "PlayerData.h" // per l'init della lista player

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
	[self.mainMenu addObject:@"Defende"];
	[self.mainMenu addObject:@"Magics"];
	[self.mainMenu addObject:@"Invocations"];
	[self.mainMenu addObject:@"Items"];
	[self.mainMenu addObject:@"Team"];
	[self.mainMenu addObject:@"Settings"];
	
	// deve essere fatta dalla sorgente dati
	self.playerList = [NSMutableArray array];
	[self.playerList addObject:[[[PlayerData alloc] initWithName:@"Vito"] autorelease]];
	[self.playerList addObject:[[[PlayerData alloc] initWithName:@"Gino"] autorelease]];
}

-(NSMutableArray *) getMenu:(NSString *)name
{
	if (@"Main" == name)
		return self.mainMenu;
	else if (@"Magics" == name)
		return [[self getPlayer:-1] getMagicMenu];
	else
		return NULL;
}

-(id) getPlayer:(int)i  // current player -1
{
	if (0 > i)
		i = self.playerSel;
	return [self.playerList objectAtIndex:i];
}

-(void) nextTurn
{
	self.playerSel = (self.playerSel + 1) % [self.playerList count];
	
	id layer = [[[CCDirector sharedDirector] runningScene] getChildByTag:1];
	[layer showTurn:[[self getPlayer:-1] name]];
}

-(void) addAction:(NSString *)name ofType:(NSString *)type toTarget:(int)target
{
	NSLog(@"----> Player: %s - %s action: %s", [[[self getPlayer:-1] name] UTF8String], [type UTF8String], [name UTF8String]);
	id layer = [[[CCDirector sharedDirector] runningScene] getChildByTag:0];
	[layer goAction];
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