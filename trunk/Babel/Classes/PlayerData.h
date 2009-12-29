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
}

@property (readwrite, assign) NSString *name;

-(id) initWithName:(NSString *)name_id;
-(NSMutableArray *) getMagicMenu;

@end