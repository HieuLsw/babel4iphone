//
//  MySequence.m
//  Genoma
//
//  Created by Giovanni Amati on 15/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MySequence.h"

@implementation MySequence

+(id) actions:(NSArray *)acts
{
	int n = [acts count];
	
	CCFiniteTimeAction *now;
	CCFiniteTimeAction *prev = [acts objectAtIndex:0];
	
	for (int i = 1; i < n; i++)
	{
		now = [acts objectAtIndex:i];
		if (now)
			prev = [CCSequence actionOne:prev two:now];
		else
			break;
	}
	
	return prev;
}

@end