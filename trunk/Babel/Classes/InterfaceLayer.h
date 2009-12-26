//
//  InterfaceLayer.h
//  Genoma
//
//  Created by Giovanni Amati on 24/11/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

@interface InterfaceLayer : CCLayer
{
	NSString *menu; // menu corrente
	int sel;        // elemento selezioanto
	int num;        // numero di item del menu corrente
}

@property (readwrite, assign) NSString *menu;
@property (readwrite, assign) int sel;
@property (readwrite, assign) int num;

-(void) initMenu:(NSString *)name;
-(void) configMenu:(int)i move:(int)m;

@end