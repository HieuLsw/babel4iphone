//
//  SharedData.h
//  Genoma
//
//  Created by Giovanni Amati on 08/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CFNetwork/CFNetwork.h>

@interface SharedData : NSObject
{
	NSMutableArray *mainMenu;   // menu principale (stringhe)
	NSMutableArray *playerList; // lista di PlayerData
	
	int playerSel;              // player attuale
	
	NSInputStream *inputStream;
	NSOutputStream *outputStream; 
}

@property (nonatomic, retain) NSMutableArray *mainMenu;
@property (nonatomic, retain) NSMutableArray *playerList;

-(void) connectToServer:(NSString *)cmd;
-(void) sendToServer:(NSString *)cmd;

-(void) initGame;                                                                 // init del game singleton
-(NSMutableArray *) getMenu:(NSString *)name;                                     // ritorna lista di stringhe del menu da visualizzare
-(id) getPlayer:(int)i;                                                           // ritorna il player i o se usi -1 l'attuale del turno
-(void) nextTurn;                                                                 // inc indice player attuale, cioe' passa al successivo della lista
-(void) addAction:(NSString *)name ofType:(NSString *)type toTarget:(int)target;
-(void) generateAction;

+(SharedData *) Initialize;

@end
