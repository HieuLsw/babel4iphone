//
//  CoreFunctions.m
//  Genoma
//
//  Created by Giovanni Amati on 19/11/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CoreFunctions.h"

#define TILE_WIDTH  64
#define TILE_HEIGHT 32

enum {
	kTagGameLayer = 0,
	kTagTileMap = 5,
	kTagPlayer = 6,
};

// TILES

enum {
	kTagTileBlock = 2,
};

@implementation CoreFunctions

+(NSMutableDictionary *) getTileInfo:(CGPoint)pos
{	
	id glayer = [[[CCDirector sharedDirector] runningScene] getChildByTag:kTagGameLayer];
	CCTMXTiledMap *tilemap = (CCTMXTiledMap *)[glayer getChildByTag:kTagTileMap]; // tag 1
	CCTMXLayer *layer0 = [tilemap layerNamed:@"Layer 0"];
	CCTMXLayer *layerColl = [tilemap layerNamed:@"Layer 1"];
	
	CGSize s = [layer0 layerSize];
	for (int x = 0; x < s.width; x++)
	{
		for (int y = 0; y < s.height; y++)
		{
			CCSprite *tile = [layer0 tileAt:ccp(x, y)];
			CGPoint tp = tile.position;
			
			CGPoint A = ccp(tp.x, tp.y + TILE_WIDTH / 2);
			CGPoint B = ccp(tp.x + TILE_WIDTH / 2, tp.y + TILE_HEIGHT);
			CGPoint C = ccp(tp.x + TILE_WIDTH, tp.y + TILE_HEIGHT / 2);
			CGPoint D = ccp(tp.x + TILE_WIDTH / 2, tp.y);
			
			if (pos.y <= B.y && pos.y >= D.y && pos.x >= A.x && pos.x <= C.x)
			{
				float x1, x2, y1, y2;
				
				if (pos.y >= A.y)
				{
					x1 = [self intersectionY:pos.y p1:A p2:B];
					x2 = [self intersectionY:pos.y p1:B p2:C];
				}
				else
				{
					x2 = [self intersectionY:pos.y p1:C p2:D];
					x1 = [self intersectionY:pos.y p1:D p2:A];
				}
				if (pos.x >= B.x)
				{
					y2 = [self intersectionX:pos.x p1:B p2:C];
					y1 = [self intersectionX:pos.x p1:C p2:D];
				}
				else
				{
					y1 = [self intersectionX:pos.x p1:D p2:A];
					y2 = [self intersectionX:pos.x p1:A p2:B];
				}
				
				if (pos.x >= x1 && pos.x <= x2 && pos.y >= y1 && pos.y <= y2)
				{					
					unsigned int gid1 = [layerColl tileGIDAt:ccp(x, y)];
					if (kTagTileBlock == gid1) return NULL; // cliccato su posizione nulla
					unsigned int gid0 = [layer0 tileGIDAt:ccp(x, y)];
					
					NSMutableDictionary *toReturn = [NSMutableDictionary dictionary];
					[toReturn setObject:[NSValue valueWithCGPoint:ccp(x, y)] forKey:@"tileIndex"];
					[toReturn setObject:[NSValue valueWithCGPoint:ccp(tp.x + TILE_WIDTH / 2, tp.y + TILE_HEIGHT / 2)] forKey:@"tilePos"];					
					[toReturn setValue:[NSNumber numberWithInt:gid0] forKey:@"tileGID"];
					[toReturn setValue:[NSNumber numberWithInt:gid1] forKey:@"tileGIDCollision"];
					
					//CCLOG(@"Click sul tile(%d, %d) == %d", (int)tp.x + TILE_WIDTH / 2, (int)tp.y + TILE_HEIGHT / 2, 0);
					return toReturn;
				}
			}
		}
	}
	
	return NULL;
}

+(float) intersectionX:(float)x p1:(CGPoint)p1 p2:(CGPoint)p2
{
	float y = (p2.y - p1.y) / (p2.x - p1.x) * (x - p1.x) + p1.y;
	return y;
}

+(float) intersectionY:(float)y p1:(CGPoint)p1 p2:(CGPoint)p2
{
	float x = (p2.x - p1.x) / (p2.y - p1.y) * (y - p1.y) + p1.x;
	return x;
}

+(NSMutableArray *)actionsFrom:(NSMutableDictionary *)start to:(NSMutableDictionary *)dest
{	
	NSMutableArray *actions = [NSMutableArray array];
	
	if (!dest || !start) return actions;
	
	CGPoint p1i;
    [[start objectForKey:@"tileIndex"] getValue:&p1i];
	CGPoint p2i;
    [[dest objectForKey:@"tileIndex"] getValue:&p2i];
	
	if (p1i.x == p2i.x && p1i.y == p2i.y) return actions;
	
	CGPoint p1;
    [[start objectForKey:@"tilePos"] getValue:&p1];
	CGPoint p2;
    [[dest objectForKey:@"tilePos"] getValue:&p2];
	
	unsigned int gid;
	float dur = 0.5;
	CGPoint temp = p1;
	
	id glayer = [[[CCDirector sharedDirector] runningScene] getChildByTag:kTagGameLayer];
	CCTMXTiledMap *tilemap = (CCTMXTiledMap *)[glayer getChildByTag:kTagTileMap]; // tag 1
	CCTMXLayer *layerColl = [tilemap layerNamed:@"Layer 1"];
	
	int i = (int)p1i.x;
	int j = (int)p1i.y;
	if (p1i.x < p2i.x)
	{
		while (i < p2i.x)
		{
			i++;
			gid = [layerColl tileGIDAt:ccp(i, j)];
			if (kTagTileBlock == gid) return actions; // cliccato su posizione nulla
			temp = ccp(p1.x - (p1i.x - i) * TILE_WIDTH / 2, p1.y + (p1i.x - i) * TILE_HEIGHT / 2);
			id action = [MyMoveTo actionWithDuration:dur position:temp];
			[actions addObject:action];
		}
	} 
	else
	{
		while (i > p2i.x)
		{
			i--;
			gid = [layerColl tileGIDAt:ccp(i, j)];
			if (kTagTileBlock == gid) return actions; // cliccato su posizione nulla
			temp = ccp(p1.x - (p1i.x - i) * TILE_WIDTH / 2, p1.y + (p1i.x - i) * TILE_HEIGHT / 2);
			id action = [MyMoveTo actionWithDuration:dur position:temp];
			[actions addObject:action];
		}
	}
	if (p1i.y < p2i.y)
	{
		while (j < p2i.y)
		{
			j++;
			gid = [layerColl tileGIDAt:ccp(i, j)];
			if (kTagTileBlock == gid) return actions; // cliccato su posizione nulla
			id action = [MyMoveTo actionWithDuration:dur position:ccp(temp.x + (p1i.y - j) * TILE_WIDTH / 2, temp.y + (p1i.y - j) * TILE_HEIGHT / 2)];
			[actions addObject:action];
		}
	} 
	else
	{
		while (j > p2i.y)
		{
			j--;
			gid = [layerColl tileGIDAt:ccp(i, j)];
			if (kTagTileBlock == gid) return actions; // cliccato su posizione nulla
			id action = [MyMoveTo actionWithDuration:dur position:ccp(temp.x + (p1i.y - j) * TILE_WIDTH / 2, temp.y + (p1i.y - j) * TILE_HEIGHT / 2)];
			[actions addObject:action];
		}
	}
	
	return actions;
}

@end