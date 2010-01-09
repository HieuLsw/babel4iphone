//
//  PlayerData.h
//  Babel
//
//  Created by Giovanni Amati on 28/12/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

@interface PlayerData : NSObject
{
	NSString *name;
	NSString *type;
}

@property (readwrite, assign) NSString *name;
@property (readwrite, assign) NSString *type;

-(NSMutableArray *) getMagicMenu; // ritorna il menu delle magie del pg in base alle sue stats (lista stringhe)

@end