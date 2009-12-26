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
	NSMutableArray *magicsMenu;
}

@property (nonatomic, retain) NSMutableArray *mainMenu;
@property (nonatomic, retain) NSMutableArray *magicsMenu;

-(void) initGame;
-(NSMutableArray *) getMenu:(NSString *)name player:(int)p;

+(SharedData *) Initialize;

@end
