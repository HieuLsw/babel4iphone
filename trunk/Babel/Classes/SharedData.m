//
//  SharedData.m
//  Genoma
//
//  Created by Giovanni Amati on 08/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SharedData.h"

@implementation SharedData

@synthesize mainMenu, magicsMenu;

-(void) dealloc
{
	NSLog(@"------------------- RELEASE SINGETON DATA ----------------------");
	[mainMenu release];
	[magicsMenu release];
	[super dealloc];
}

-(void) initGame
{
	self.mainMenu = [NSMutableArray array];
	[self.mainMenu addObject:@"Attack"];
	[self.mainMenu addObject:@"Magics"];
	[self.mainMenu addObject:@"Invocations"];
	[self.mainMenu addObject:@"Items"];
	[self.mainMenu addObject:@"Team"];
	[self.mainMenu addObject:@"Settings"];
		
	NSMutableArray *p0 = [NSMutableArray array];
	[p0 addObject:@"Fire      25"];
	[p0 addObject:@"Wind      25"];
	[p0 addObject:@"Water     25"];
	[p0 addObject:@"Blizard   25"];
	[p0 addObject:@"Earth     25"];
	
	self.magicsMenu = [NSMutableArray array];
	[self.magicsMenu insertObject:p0 atIndex:0];
}

-(NSMutableArray *) getMenu:(NSString *)name player:(int)p
{
	if (@"mainMenu" == name)
		return self.mainMenu;
	else if (@"magicsMenu" == name)
		return [self.magicsMenu objectAtIndex:p];
	else
		return NULL;
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