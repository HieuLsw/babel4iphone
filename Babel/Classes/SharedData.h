//
//  SharedData.h
//  Genoma
//
//  Created by Giovanni Amati on 08/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

@interface SharedData : NSObject
{
	NSMutableArray *mainMenu;
	NSMutableArray *playerList;
	int playerSel;
}

@property (nonatomic, retain) NSMutableArray *mainMenu;
@property (nonatomic, retain) NSMutableArray *playerList;
@property (readwrite, assign) int playerSel;

-(void) initGame;
-(NSMutableArray *) getMenu:(NSString *)name;
-(void) nextTurn;

+(SharedData *) Initialize;

@end
