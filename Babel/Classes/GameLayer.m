//
//  GameLayer.m
//  Genoma
//
//  Created by Giovanni Amati on 08/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "GameLayer.h"

enum {
	kTagGameLayer = 0,
	kTagInterfaceLayer = 1,
	kTagTileMap = 5,
	kTagPlayer = 6,
	kTagPlayerSel = 7,
};

@implementation GameLayer

@synthesize mapIndex, playerSel;

-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if ((self = [super init]))
	{
		self.isTouchEnabled = YES;		
	}
	
	return self;
}

-(void) loadWithMap:(int)map playerPos:(CGPoint)pos
{
	mapIndex = map;
	playerSel = 0;
	
	// LOAD MAP
	
	//CCSprite *back = [CCSprite spriteWithFile:@"Default2.png"];
	//[back setAnchorPoint:ccp(0, 0)];
	//[self addChild:back z:-1];
	
	// usare indici x caricare map diverse
	NSString *file = [[@"level" stringByAppendingString:[NSString stringWithFormat:@"%d", mapIndex]] stringByAppendingString:@".tmx"];
	CCTMXTiledMap *tileMap = [CCTMXTiledMap tiledMapWithTMXFile:file];
	[self addChild:tileMap z:0 tag:kTagTileMap]; // tag 1
	
	for (CCSpriteSheet* child in [tileMap children])
		[[child texture] setAntiAliasTexParameters];
	
	[tileMap reorderChild:[tileMap layerNamed:@"Layer 0"] z:1];
	[tileMap reorderChild:[tileMap layerNamed:@"Layer coll"] z:0]; // livello delle collisioni, nel fondo
	
	// LOAD SPRITE
		
	CCSprite *selection = [CCSprite spriteWithFile:@"selezione.png"];
	[tileMap addChild:selection z:3 tag:kTagPlayerSel]; // il pg sulla tile map e' taggato con 2 la tilemap 1
	[selection setVisible:NO];
	[selection setOpacity:99];
	
	//players = [NSMutableArray array];
	
	CCSpriteSheet *mgr_player = [CCSpriteSheet spriteSheetWithFile:@"grossini_dance_atlas.png" capacity:50];
	[tileMap addChild:mgr_player z:4 tag:kTagPlayer]; // il pg sulla tile map e' taggato con 2 la tilemap 1
	//[players addObject:mgr_player];
	
	[mgr_player setPosition:pos];
	[mgr_player setScale:0.6f];
	
	// animation
	CCSprite *sprite = [mgr_player createSpriteWithRect:CGRectMake(0, 0, 85, 121)];
	[mgr_player addChild:sprite];
	
	[sprite setAnchorPoint:ccp(0.5, 0.05)];
	
	CCAnimation *animation = [CCAnimation animationWithName:@"dance" delay:0.2f];
	for (int i = 0; i < 14; i++)
	{
		int x = i % 5;
		int y = i / 5;
		[animation addFrameWithTexture:sprite.texture rect:CGRectMake(x * 85, y * 121, 85, 121)];
	}
	
	id action1 = [CCAnimate actionWithAnimation:animation];
	id action2 = [CCRepeatForever actionWithAction:action1];
	[sprite runAction:action2];
	
	// INIT CAMERA (simile alle implementazione in MyMoveTo vedere....)
	
	// x,y,z della camera sono al centro del display, mentre quelli della tilemap nel left-bottom (0,0 nn viene mai spostata)
	// visto che i calcoli partono dalla posizione del pg ci sono calcoli da fare per il posizionamento giusto della telecamera
	//CGSize s = [[CCDirector sharedDirector] displaySize];
	//float x = pos.x - s.width / 4; // camera pos standard relative to start pos player
	//float y = pos.y + s.height / 4 - 64; // fix spostamento dalla tile lunga
	//float z = s.height / 1.1566f;
	
	//[self.camera setCenterX:x centerY:y centerZ:0]; // serve il self
	//[self.camera setEyeX:x eyeY:y eyeZ:z];
}

-(void) nextScene:(CGPoint)pos
{	
	// calcolare nextMap da mapIndex attuale e da dove e' il tile di transizione e quindi anche il pg
	int nextMap = 0;
	CGPoint nextPos = ccp(700, 700);
	// fine calc
	
	CCScene *scene = [CCScene node];
	
	GameLayer *glayer = [GameLayer node];
	[glayer loadWithMap:nextMap playerPos:nextPos];
	InterfaceLayer *mlayer = [InterfaceLayer node];
	
	[scene addChild:glayer z:0 tag:kTagGameLayer]; // tag 0
	[scene addChild:mlayer z:1 tag:kTagInterfaceLayer]; // 1 tag del menu layer
	[[CCDirector sharedDirector] replaceScene:[CCFadeTransition transitionWithDuration:1.5f scene:scene]];
}

-(void) touchManage:(CGPoint)pos
{
	CCTMXTiledMap *tilemap = (CCTMXTiledMap *)[self getChildByTag:kTagTileMap]; // tag 1
	
	NSMutableDictionary *dest = [CoreFunctions getTileInfo:pos];
	CGPoint destIndex;
    [[dest objectForKey:@"tileIndex"] getValue:&destIndex];
	
	///
	int gid = 0;
	CGPoint destPos;
	[[dest objectForKey:@"tilePos"] getValue:&destPos];
	[[dest objectForKey:@"tileGID"] getValue:&gid];
	CCLOG(@"------------>  %d, %d -- %d, %d = %d", (int)destIndex.x, (int)destIndex.y, (int)destPos.x, (int)destPos.y, (int)gid);
	///
	
	int selp = 0;
	
	CCSpriteSheet *mgr_player = (CCSpriteSheet *)[tilemap getChildByTag:kTagPlayer]; // tag 2
	CGPoint plpos = mgr_player.position;
	
	NSMutableDictionary *source = [CoreFunctions getTileInfo:plpos];
	CGPoint sourceIndex;
    [[source objectForKey:@"tileIndex"] getValue:&sourceIndex];
	
	CCLOG(@"------------>  %d, %d", (int)sourceIndex.x, (int)sourceIndex.y);
	
	if (destIndex.x == sourceIndex.x && destIndex.y == sourceIndex.y)
		selp = 1;
	
	if (0 != selp)
	{
		CCSprite *selection = (CCSprite *)[tilemap getChildByTag:kTagPlayerSel];
		if (selp != playerSel)
		{
			[selection setPosition:mgr_player.position];
			[selection setVisible:YES];
			playerSel = selp;
		}
		else
		{
			[selection setVisible:NO];
			playerSel = 0;
		}
	}
	
	if (0 != playerSel)
	{
		//unsigned int gid;
		//[[dest objectForKey:@"tileGIDCollision"] getValue:&gid];
		//if (2 == gid)
		//{
			//CCLOG(@"---------> %d", gid);
		//	[self nextScene:pos];
		//}
		NSMutableArray *actions = [CoreFunctions actionsFrom:source to:dest];
		if (0 != [actions count])
		{
			[mgr_player stopAllActions];
			[mgr_player runAction:[MySequence actions:actions]];
		}
	}
}

-(BOOL) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [touches anyObject];
	
	CGPoint touchLocation = [touch locationInView:[touch view]];
	touchLocation = [[CCDirector sharedDirector] convertToGL:touchLocation];
	
	float x, y, z;
	[self.camera centerX:&x centerY:&y centerZ:&z]; // coordinate camera
	//// x,y,z della camera sono al centro del display, mentre quelli della tilemap nel left-bottom (0,0 nn viene mai spostata) 
	CGSize s = [[CCDirector sharedDirector] displaySize];
	float absoluteX = x - s.width / 2 + touchLocation.x;
	float absoluteY = y - s.height / 2 + touchLocation.y;
	
	[self touchManage:ccp(absoluteX, absoluteY)];
	
	return YES;
}

-(BOOL) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	if (0 == playerSel)
	{
		UITouch *touch = [touches anyObject];
		
		CGPoint touchLocation = [touch locationInView: [touch view]];
		CGPoint prevLocation = [touch previousLocationInView: [touch view]];
		
		touchLocation = [[CCDirector sharedDirector] convertToGL: touchLocation];
		prevLocation = [[CCDirector sharedDirector] convertToGL: prevLocation];
		
		CGPoint diff = ccpSub(touchLocation, prevLocation);
		
		float x, y, z;
		[self.camera centerX:&x centerY:&y centerZ:&z]; // coordinate camera
		CGPoint temp = ccpSub(ccp(x, y), diff);
		
		[self.camera setCenterX:temp.x centerY:temp.y centerZ:0];
		[self.camera setEyeX:temp.x eyeY:temp.y eyeZ:CCCamera.getZEye];
	}
	
	return YES;
}

// on "dealloc" you need to release all your retained objects
-(void) dealloc
{	
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}

@end