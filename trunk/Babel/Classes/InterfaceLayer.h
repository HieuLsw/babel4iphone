//
//  InterfaceLayer.h
//  Genoma
//
//  Created by Giovanni Amati on 24/11/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

@interface MyAction : CCIntervalAction
{
	NSString *myType;
}

@property (readwrite, assign) NSString *myType;

// un metodo x ogni azione personalizzata nel metodo si setta il tipo e durata in update l'if x i comendi da eseguire

+(id) showMenu;

@end

// fine classe utils

@interface InterfaceLayer : CCLayer
{
	NSString *menu; // nome del menu corrente
	int sel;        // indice dell'elemento selezionato del menu corrente
	int num;        // numero di item del menu corrente
	bool active;
}

@property (readwrite, assign) NSString *menu;
@property (readwrite, assign) int sel;
@property (readwrite, assign) int num;
@property (readwrite, assign) bool active;

-(void) initMenu:(NSString *)name;       // inizializza il menu "name"
-(void) configItem:(int)i move:(int)m;   // anima il menu in base a i e m
-(void) getTurn;                        // imposta il turno

@end