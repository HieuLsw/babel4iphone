//
//  GameLayer.h
//  Genoma
//
//  Created by Giovanni Amati on 08/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "CoreFunctions.h"
#import "MySequence.h"

#import "InterfaceLayer.h"

@interface GameLayer : CCLayer
{
	int mapIndex;
	int playerSel;
}

@property (readwrite, assign) int mapIndex;
@property (readwrite, assign) int playerSel;

-(void) loadWithMap:(int)map playerPos:(CGPoint)pos;
-(void) nextScene:(CGPoint)pos;
-(void) touchManage:(CGPoint)pos;

@end