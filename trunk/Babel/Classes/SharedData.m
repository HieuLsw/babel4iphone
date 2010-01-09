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
	
	id p1 = [[[PlayerData alloc] init] autorelease];
	[p1 setName:@"Vito"];
	[p1 setType:@"Human"];
	id p2 = [[[PlayerData alloc] init] autorelease];
	[p2 setName:@"Gino"];
	[p2 setType:@"Human"];
	id p3 = [[[PlayerData alloc] init] autorelease];
	[p3 setName:@"Monter"];
	[p3 setType:@"NPC"];
	
	[self.playerList addObject:p1];
	[self.playerList addObject:p2];
	[self.playerList addObject:p3];
	
	self.playerSel = arc4random() % [self.playerList count]; // x ora il turno comincia random
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
	[layer getTurn];
}

-(void) addAction:(NSString *)name ofType:(NSString *)type toTarget:(int)target
{
	NSLog(@"----> Player: %s - %s action: %s", [[[self getPlayer:-1] name] UTF8String], [type UTF8String], [name UTF8String]);
	// creare una lista di azioni da fare in gamelayer
}

-(void) generateAction
{
	NSLog(@"----> NPC: %s IA generate a action and target", [[[self getPlayer:-1] name] UTF8String]);
	// creare una lista di azioni da fare in gamelayer
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