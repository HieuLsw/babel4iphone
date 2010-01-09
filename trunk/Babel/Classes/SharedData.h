//
//  SharedData.h
//  Genoma
//
//  Created by Giovanni Amati on 08/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

@interface SharedData : NSObject
{
	NSMutableArray *mainMenu;   // menu principale (stringhe)
	NSMutableArray *playerList; // lista di PlayerData
	int playerSel;              // player attuale
}

@property (nonatomic, retain) NSMutableArray *mainMenu;
@property (nonatomic, retain) NSMutableArray *playerList;
@property (readwrite, assign) int playerSel;

-(void) initGame;                                                                 // init del game singleton
-(NSMutableArray *) getMenu:(NSString *)name;                                     // ritorna lista di stringhe del menu da visualizzare
-(id) getPlayer:(int)i;                                                           // ritorna il player i o se usi -1 l'attuale del turno
-(void) nextTurn;                                                                 // inc indice player attuale, cioe' passa al successivo della lista
-(void) addAction:(NSString *)name ofType:(NSString *)type toTarget:(int)target;  // cambia dati dei players (singleton) e si ripercuote sul GameLayer

+(SharedData *) Initialize;

@end
